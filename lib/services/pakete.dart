import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'paket_verzeichnis.dart';
import 'sprache.dart';
import 'sprachausgabe.dart';

/// Die Aufnahmen kommen als Pakete nach, getrennt von der App: je Sprache „Lektionen“ und
/// „Geführte Audios“ (Gemeinsamer Abend, Selbsterkundung, Einschlaf-Reise). In der App bleiben nur die
/// Ansagen des Beckenboden-Trainings, Klangschale und Klangteppich.
///
/// Ein Paket ist ein ZIP mit derselben Struktur wie früher assets/ (audio/<lektion>.opus, audio/paar/…,
/// audio/selbst/…, audio/einschlaf/…) und einer paket.json ({"name", "version"}). Adressen, Größe und
/// SHA-256 stehen im signierten [PaketVerzeichnis]. Fehlt ein Paket oder eine Datei darin, liest die
/// Geräte-Stimme. Konzept: docs/konzepte/traum-reise.md, „Audio: Bausteine und Pakete“.
class Pakete {
  static const lektionen = 'lektionen';
  static const gefuehrt = 'gefuehrt';
  static const arten = [lektionen, gefuehrt];

  /// Name im Verzeichnis, z. B. „de-lektionen“.
  static String name(String art, [String? sprache]) => '${sprache ?? Sprache.code}-$art';

  static String? _basis;

  static Future<void> init() async {
    try {
      _basis = '${(await getApplicationSupportDirectory()).path}/pakete';
    } catch (_) {
      _basis = null;
    }
  }

  @visibleForTesting
  static set basisFuerTest(String? pfad) => _basis = pfad;

  /// Fortschritt 0…1 je Paketname während des Ladens.
  static final ValueNotifier<Map<String, double>> fortschritt = ValueNotifier({});

  /// Ändert sich, wenn ein Paket installiert oder gelöscht wurde.
  static final ValueNotifier<int> stand = ValueNotifier(0);

  static String? _ordner(String name) => _basis == null ? null : '$_basis/$name';

  /// Vollständiger Pfad einer Aufnahme (z. B. 'audio/paar/victoria_ankommen_1.opus') in der aktuellen Sprache,
  /// oder null. Englisch fällt zusätzlich auf das alte Audiopaket zurück, damit nichts verloren geht.
  static String? datei(String pfad) {
    for (final art in arten) {
      final o = _ordner(name(art));
      if (o == null) break;
      final f = File('$o/$pfad');
      if (f.existsSync()) return f.path;
    }
    return Sprache.englisch ? AudioPaket.datei(pfad) : null;
  }

  /// Installierte Version, 0 ohne Paket.
  static int version(String name) {
    final o = _ordner(name);
    if (o == null) return 0;
    final f = File('$o/paket.json');
    if (!f.existsSync()) return 0;
    try {
      return (jsonDecode(f.readAsStringSync()) as Map)['version'] as int;
    } catch (_) {
      return 0;
    }
  }

  /// Gilt als vorhanden; Englisch auch mit dem alten Audiopaket (enthält Lektionen und geführte Audios).
  static bool vorhanden(String art, [String? sprache]) {
    final s = sprache ?? Sprache.code;
    return version(name(art, s)) > 0 || (s == 'en' && AudioPaket.vorhanden);
  }

  /// Fehlt für die aktuelle Sprache noch ein Paket?
  static bool get unvollstaendig => arten.any((a) => !vorhanden(a));

  static int belegtMb(String name) {
    final o = _ordner(name);
    if (o == null || !Directory(o).existsSync()) return 0;
    var bytes = 0;
    for (final f in Directory(o).listSync(recursive: true)) {
      if (f is File) bytes += f.lengthSync();
    }
    return (bytes / 1e6).round();
  }

  /// Lädt ein Paket laut [PaketVerzeichnis], prüft Größe und SHA-256 und installiert es. Probiert die
  /// Adressen nacheinander. Wirft bei jedem Fehler; ein vorhandenes Paket bleibt dann unverändert.
  static Future<void> laden(String name, {http.Client? client, PaketVerzeichnis? verzeichnis}) async {
    final o = _ordner(name);
    if (o == null) throw StateError('Kein Speicherort');
    final c = client ?? http.Client();
    final zip = File('$o.download.zip');
    fortschritt.value = {...fortschritt.value, name: 0};
    try {
      final eintrag = (verzeichnis ?? await PaketVerzeichnis.laden(client: c))?.paket(name);
      if (eintrag == null) throw StateError('Paket $name nicht im Verzeichnis');
      Object? letzterFehler;
      for (final quelle in eintrag.adressen) {
        try {
          final antwort = await c.send(http.Request('GET', Uri.parse(quelle)));
          if (antwort.statusCode != 200) throw StateError('Download fehlgeschlagen (${antwort.statusCode})');
          Directory(o).parent.createSync(recursive: true);
          var geladen = 0;
          final senke = zip.openWrite();
          await for (final teil in antwort.stream) {
            senke.add(teil);
            geladen += teil.length;
            if (geladen > eintrag.groesse) throw StateError('Paket größer als angegeben');
            fortschritt.value = {...fortschritt.value, name: geladen / eintrag.groesse * 0.9};
          }
          await senke.close();
          if (geladen != eintrag.groesse) throw StateError('Paket unvollständig');
          final ist = (await sha256.bind(zip.openRead()).first).toString();
          if (ist != eintrag.sha256) throw StateError('Prüfsumme stimmt nicht');
          await AudioPaket.installieren(zip.path, o, pflichtDatei: 'paket.json');
          stand.value++;
          return;
        } catch (e) {
          letzterFehler = e;
          debugPrint('Paket $name: $quelle nicht nutzbar (${e.runtimeType})');
        }
      }
      throw letzterFehler ?? StateError('Keine Adresse');
    } finally {
      if (zip.existsSync()) zip.deleteSync();
      fortschritt.value = {...fortschritt.value}..remove(name);
      if (client == null) c.close();
    }
  }

  static Future<void> loeschen(String name) async {
    final o = _ordner(name);
    if (o != null && Directory(o).existsSync()) Directory(o).deleteSync(recursive: true);
    stand.value++;
  }
}
