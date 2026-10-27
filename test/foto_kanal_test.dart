// Fotos von Handy zu Handy: zwei simulierte Handys, Signale und Verbindung im Speicher.
import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velvetpulse/services/foto_kanal.dart';
import 'package:velvetpulse/services/foto_verbindung.dart';

/// Ein Handy: empfängt Signale und Foto-Angebote vom anderen.
class FakeBote implements FotoBote {
  FakeBote? gegenueber;

  /// App offen: Signale kommen an.
  bool online = true;

  /// Server verbunden: Ohne Verbindung geht kein Signal raus (wie direkt nach dem Start).
  bool verbunden = true;

  /// Foto-Nachrichten kommen erst mit [nachrichtenZustellen] an, wie nach einer Offline-Zeit, wenn die
  /// App schon läuft, die Server die alten Nachrichten aber erst nach und nach liefern.
  bool nachrichtenVerzoegern = false;

  /// Signal-Arten, die auf dem Weg zu diesem Handy verloren gehen.
  final Set<String> verwerfen = {};

  final _signale = StreamController<Map<String, dynamic>>.broadcast();
  final Map<String, Map<String, dynamic>> angebote = {};
  final Map<String, Map<String, dynamic>> _unterwegs = {};
  final List<Map<String, Object?>> gesendeteSignale = [];
  final _anlass = ValueNotifier(0);

  @override
  Stream<Map<String, dynamic>> get signale => _signale.stream;

  @override
  Listenable get anlass => _anlass;

  void meldeAnlass() => _anlass.value++;

  void nachrichtenZustellen() {
    angebote.addAll(_unterwegs);
    _unterwegs.clear();
    meldeAnlass();
  }

  @override
  Future<bool> sendSignal(Map<String, Object?> daten) async {
    gesendeteSignale.add(daten);
    if (!verbunden) return false;
    final g = gegenueber;
    if (g != null && g.online && g.verbunden && !g.verwerfen.contains(daten['t'])) {
      g._signale.add(Map<String, dynamic>.from(daten));
    }
    return true;
  }

  @override
  Future<bool> sendFotoAngebot(Map<String, Object> angaben, {bool verschwindet = false}) async {
    final g = gegenueber!;
    (g.nachrichtenVerzoegern ? g._unterwegs : g.angebote)[angaben['id'] as String] =
        Map<String, dynamic>.from(angaben);
    return true;
  }

  @override
  Future<Map<String, dynamic>?> fotoAngebot(String id) async => angebote[id];

  @override
  Future<void> fotoVergessen(String id) async => angebote.remove(id);

  @override
  List<String> get empfangeneFotoIds => angebote.keys.toList();
}

/// Verbindung im Speicher: das Angebot trägt eine Nummer, die Antwort verbindet beide Seiten.
class FakeNetz {
  final Map<String, FakeVerbindung> offen = {};
  var zaehler = 0;

  FotoVerbindung fabrik({
    required void Function(Map<String, dynamic>) kandidat,
    void Function(Uint8List)? daten,
    void Function()? beendet,
  }) =>
      FakeVerbindung(this, daten, beendet);
}

class FakeVerbindung implements FotoVerbindung {
  FakeVerbindung(this.netz, this.daten, this.beendet);
  final FakeNetz netz;
  final void Function(Uint8List)? daten;
  final void Function()? beendet;
  FakeVerbindung? andere;
  final _offen = Completer<void>();

  @override
  Future<String> angebotErstellen() async {
    final sdp = 'angebot-${netz.zaehler++}';
    netz.offen[sdp] = this;
    return sdp;
  }

  @override
  Future<String> antwortErstellen(String angebot) async {
    andere = netz.offen.remove(angebot)!..andere = this;
    andere!._offen.complete();
    return 'antwort';
  }

  @override
  Future<void> antwortSetzen(String antwort) async {}
  @override
  Future<void> kandidatSetzen(Map<String, dynamic> kandidat) async {}
  @override
  Future<void> get offen => _offen.future;
  @override
  Future<void> senden(Uint8List teil) async => andere!.daten?.call(Uint8List.fromList(teil));
  @override
  Future<void> ende() async => andere!.beendet?.call();
  @override
  Future<void> schliessen() async {}
}

void main() {
  late Directory tmp;
  late FakeBote anna, ben;
  late FakeNetz netz;
  late FotoKanal annaKanal, benKanal;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    tmp = Directory.systemTemp.createTempSync('fotos');
    anna = FakeBote();
    ben = FakeBote();
    anna.gegenueber = ben;
    ben.gegenueber = anna;
    netz = FakeNetz();
    annaKanal = FotoKanal.fuerTest(anna, netz.fabrik, () async => '${tmp.path}/anna', 'anna_');
    benKanal = FotoKanal.fuerTest(ben, netz.fabrik, () async => '${tmp.path}/ben', 'ben_');
  });
  tearDown(() async {
    annaKanal.stop();
    benKanal.stop();
    // Laufende Übertragungen (5 s Nachlauf) ausklingen lassen, bevor der Ordner verschwindet.
    await Future.delayed(const Duration(milliseconds: 50));
    if (tmp.existsSync()) tmp.deleteSync(recursive: true);
  });

  final bild = Uint8List.fromList(List.generate(70000, (i) => i % 251));

  Future<void> warten() => Future.delayed(const Duration(milliseconds: 200));

  /// Wartet, bis die Übertragung durch ist; fest 200 ms reichen unter Last (alle Tests parallel) nicht immer.
  Future<String?> zustandAbwarten(FotoKanal kanal, String id, String ziel) async {
    String? z;
    for (var i = 0; i < 50; i++) {
      z = await kanal.zustand(id, vonMir: false);
      if (z == ziel) break;
      await Future.delayed(const Duration(milliseconds: 100));
    }
    return z;
  }

  test('Beide online: Foto kommt direkt an, lässt sich genau einmal ansehen', () async {
    await annaKanal.start();
    await benKanal.start();
    final ergebnis = await annaKanal.senden(bild);
    expect(ergebnis, FotoErgebnis.unterwegs);
    final id = ben.angebote.keys.single;
    expect(await zustandAbwarten(benKanal, id, 'bereit'), 'bereit');
    await warten(); // Empfangsbestätigung an Anna
    expect(annaKanal.status.value[id], 'zugestellt');
    expect(File('${tmp.path}/anna/raus_$id.bin').existsSync(), isFalse, reason: 'beim Absender gelöscht');
    // Auf der Platte liegt beim Empfänger nur Verschlüsseltes.
    expect(File('${tmp.path}/ben/rein_$id.bin').readAsBytesSync(), isNot(bild));

    expect(await benKanal.einmalOeffnen(id), bild);
    await warten();
    expect(await benKanal.einmalOeffnen(id), isNull, reason: 'nur einmal');
    expect(ben.angebote, isEmpty, reason: 'Schlüssel vergessen');
    expect(annaKanal.status.value[id], 'angesehen');
  });

  test('Gegenüber offline: Foto wartet verschlüsselt und kommt beim nächsten gemeinsamen Online-Sein', () async {
    ben.online = false;
    await annaKanal.start();
    expect(await annaKanal.senden(bild), FotoErgebnis.wartet);
    final id = ben.angebote.keys.single;
    expect(File('${tmp.path}/anna/raus_$id.bin').existsSync(), isTrue);
    // Die Prüfnachricht („da?“) ist ein Signal, keine Chat-Nachricht.
    expect(anna.gesendeteSignale.map((s) => s['t']), contains('da?'));

    ben.online = true;
    await benKanal.start(); // Ben öffnet die App und meldet fehlende Fotos.
    expect(await zustandAbwarten(benKanal, id, 'bereit'), 'bereit');
    expect(await benKanal.einmalOeffnen(id), bild);
  });

  // Die folgenden Fälle stellen den Fehler vom 25.10.2026 nach: Beide hatten die App offen, und das Foto
  // blieb trotzdem bei „Foto wartet: öffnet beide VelvetPulse“ stehen.

  test('Foto-Nachricht kommt erst nach dem Start an: Abgleich fordert das Foto dann an', () async {
    ben.online = false;
    ben.nachrichtenVerzoegern = true;
    await annaKanal.start();
    expect(await annaKanal.senden(bild), FotoErgebnis.wartet);

    ben.online = true;
    await benKanal.start(); // Ben kennt die Foto-Nachricht noch nicht: nichts anzufordern.
    expect(ben.gesendeteSignale.where((s) => s['t'] == 'hallo'), isEmpty);
    ben.nachrichtenZustellen(); // Die Server liefern die Nachricht nach.
    final id = ben.angebote.keys.single;
    expect(await zustandAbwarten(benKanal, id, 'bereit'), 'bereit');
  });

  test('Server beim Start noch nicht verbunden: Anfrage geht beim Verbinden noch einmal raus', () async {
    ben.online = false;
    await annaKanal.start();
    await annaKanal.senden(bild);
    final id = ben.angebote.keys.single;

    ben.online = true;
    ben.verbunden = false;
    await benKanal.start(); // „hallo“ kann nicht raus
    expect(await benKanal.zustand(id, vonMir: false), 'wartet');
    ben.verbunden = true;
    ben.meldeAnlass(); // Verbindung steht
    expect(await zustandAbwarten(benKanal, id, 'bereit'), 'bereit');
  });

  test('Ohne jeden Anlass: der regelmäßige Abgleich holt verlorene Anfragen nach', () async {
    benKanal = FotoKanal.fuerTest(ben, netz.fabrik, () async => '${tmp.path}/ben', 'ben_',
        takt: const Duration(milliseconds: 300));
    ben.online = false;
    await annaKanal.start();
    await annaKanal.senden(bild);
    final id = ben.angebote.keys.single;

    ben.online = true;
    ben.verwerfen.add('da?'); // Antworten gehen verloren …
    anna.verwerfen.add('hallo'); // … und Bens Anfrage auch.
    await benKanal.start();
    expect(await benKanal.zustand(id, vonMir: false), 'wartet');
    anna.verwerfen.clear();
    ben.verwerfen.clear();
    expect(await zustandAbwarten(benKanal, id, 'bereit'), 'bereit');
  });

  test('Liegt das Foto beim Absender nicht mehr, wartet der Empfänger nicht ewig', () async {
    ben.angebote['alt'] = {'id': 'alt', 'key': 'AAAA', 'size': 1, 'sha': '0'};
    await annaKanal.start();
    await benKanal.start();
    await warten();
    expect(await benKanal.zustand('alt', vonMir: false), 'fehler');
    final anfragen = ben.gesendeteSignale.where((s) => s['t'] == 'hallo').length;
    await benKanal.abgleichen();
    expect(ben.gesendeteSignale.where((s) => s['t'] == 'hallo').length, anfragen, reason: 'fragt nicht mehr');
  });

  test('Verlorene Empfangsbestätigung: beim nächsten Angebot bestätigt der Empfänger erneut', () async {
    await annaKanal.start();
    await benKanal.start();
    anna.verwerfen.add('erhalten');
    await annaKanal.senden(bild);
    final id = ben.angebote.keys.single;
    expect(await zustandAbwarten(benKanal, id, 'bereit'), 'bereit');
    // Anna hat keine Bestätigung bekommen; ihr Versuch läuft noch kurz nach, danach wartet das Foto wieder.
    await Future.delayed(const Duration(seconds: 6));
    expect(annaKanal.status.value[id], 'wartet');
    anna.verwerfen.clear();
    await annaKanal.abgleichen();
    await warten();
    expect(annaKanal.status.value[id], 'zugestellt');
    expect(File('${tmp.path}/anna/raus_$id.bin').existsSync(), isFalse);
  });

  test('Nicht ausgelieferte Fotos werden nach sieben Tagen gelöscht', () async {
    ben.online = false;
    await annaKanal.start();
    await annaKanal.senden(bild);
    final id = ben.angebote.keys.single;
    await annaKanal.aufraeumenFuerTest(DateTime.now().add(const Duration(days: 8)));
    expect(File('${tmp.path}/anna/raus_$id.bin').existsSync(), isFalse);
    expect(annaKanal.status.value[id], 'fehler');
  });
}
