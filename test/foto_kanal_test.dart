// Fotos von Handy zu Handy: zwei simulierte Handys, Signale und Verbindung im Speicher.
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velvetpulse/services/foto_kanal.dart';
import 'package:velvetpulse/services/foto_verbindung.dart';

/// Ein Handy: empfängt Signale und Foto-Angebote vom anderen.
class FakeBote implements FotoBote {
  FakeBote? gegenueber;
  bool online = true;
  final _signale = StreamController<Map<String, dynamic>>.broadcast();
  final Map<String, Map<String, dynamic>> angebote = {};
  final List<Map<String, Object?>> gesendeteSignale = [];

  @override
  Stream<Map<String, dynamic>> get signale => _signale.stream;

  @override
  Future<bool> sendSignal(Map<String, Object?> daten) async {
    gesendeteSignale.add(daten);
    if (gegenueber?.online ?? false) gegenueber!._signale.add(Map<String, dynamic>.from(daten));
    return true;
  }

  @override
  Future<bool> sendFotoAngebot(Map<String, Object> angaben, {bool verschwindet = false}) async {
    gegenueber!.angebote[angaben['id'] as String] = Map<String, dynamic>.from(angaben);
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
  late FotoKanal annaKanal, benKanal;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    tmp = Directory.systemTemp.createTempSync('fotos');
    anna = FakeBote();
    ben = FakeBote();
    anna.gegenueber = ben;
    ben.gegenueber = anna;
    final netz = FakeNetz();
    annaKanal = FotoKanal.fuerTest(anna, netz.fabrik, () async => '${tmp.path}/anna', 'anna_');
    benKanal = FotoKanal.fuerTest(ben, netz.fabrik, () async => '${tmp.path}/ben', 'ben_');
  });
  tearDown(() => tmp.deleteSync(recursive: true));

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
