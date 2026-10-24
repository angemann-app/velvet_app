import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'sprache.dart';
import 'tts_service.dart';
import 'update_service.dart';

/// Gesprochene Texte in der aktuellen Sprache.
///
/// Deutsch: die Aufnahmen aus der App (assets/audio/…).
/// Englisch: die Aufnahmen aus dem nachgeladenen englischen Audiopaket ([AudioPaket]); solange es
/// fehlt oder eine Datei darin fehlt, liest die Geräte-Stimme den Text vor.
class Sprachausgabe {
  static final TtsService _tts = TtsService();

  /// Aufnahme für [pfad] (z. B. 'audio/paar/victoria_ankommen_1.opus') oder null, wenn es keine gibt.
  static Source? quelle(String pfad) {
    if (!Sprache.englisch) return AssetSource(pfad);
    final datei = AudioPaket.datei(pfad);
    return datei == null ? null : DeviceFileSource(datei);
  }

  /// Spielt die Aufnahme über [player] oder liest [text] mit der Geräte-Stimme vor.
  static Future<void> sprich(AudioPlayer player, String pfad, String text) async {
    final q = quelle(pfad);
    if (q != null) {
      await player.play(q).catchError((_) {});
    } else {
      await _tts.speak(text, contextId: pfad);
    }
  }

  static Future<void> pause(AudioPlayer player) async {
    await player.pause().catchError((_) {});
    await _tts.stop();
  }

  static Future<void> stopp(AudioPlayer player) async {
    await player.stop().catchError((_) {});
    await _tts.stop();
  }

  /// Nur das Vorlesen beenden (z. B. beim Schließen eines Bildschirms).
  static Future<void> vorlesenBeenden() => _tts.stop();
}

/// Das englische Audiopaket: nachgeladen in den privaten App-Speicher (audio_en/…), gleiche Struktur
/// wie assets/ (audio/<lektion>.opus, audio/paar/…, audio/selbst/…, audio/cues/…).
class AudioPaket {
  static String? _ordner;

  /// Ordner bestimmen (einmal beim Start); ohne ihn gilt das Paket als nicht vorhanden.
  static Future<void> init() async {
    try {
      _ordner = '${(await getApplicationSupportDirectory()).path}/audio_en';
    } catch (_) {
      _ordner = null;
    }
  }

  static String? get ordner => _ordner;

  static bool get vorhanden => _ordner != null && File('$_ordner/audio/version.txt').existsSync();

  /// Vollständiger Pfad einer Datei aus dem Paket, oder null.
  static String? datei(String pfad) {
    final o = _ordner;
    if (o == null) return null;
    final f = File('$o/$pfad');
    return f.existsSync() ? f.path : null;
  }

  // ---------------------------------------------------------------------------
  // Nachladen

  /// Liegt als eigenes Release (Tag ohne „+Build“, wird von der Update-Suche nie gewählt).
  static const String paketUrl =
      'https://github.com/${UpdateService.repo}/releases/download/audio-en-v1/velvetpulse-audio-en.zip';
  static const String pruefsummeUrl = '$paketUrl.sha256';

  /// Ungefähre Größe für die Anzeige (tools/generate_audio_en.py gibt die genaue aus).
  static const int ungefaehrMb = 45;

  /// Fortschritt 0…1 während des Ladens, sonst null.
  static final ValueNotifier<double?> fortschritt = ValueNotifier<double?>(null);

  /// Ändert sich, wenn das Paket installiert oder gelöscht wurde (für die Anzeige).
  static final ValueNotifier<int> stand = ValueNotifier<int>(0);

  /// Lädt das Paket, prüft die SHA-256-Prüfsumme und entpackt es. Wirft bei jedem Fehler;
  /// dann bleibt ein vorhandenes Paket unverändert.
  static Future<void> laden({http.Client? client}) async {
    final o = _ordner;
    if (o == null) throw StateError('Kein Speicherort');
    final c = client ?? http.Client();
    final zip = File('$o.download.zip');
    fortschritt.value = 0;
    try {
      final shaAntwort = await c.get(Uri.parse(pruefsummeUrl)).timeout(const Duration(seconds: 20));
      final soll = shaAntwort.statusCode == 200 ? UpdateService.parseSha256(shaAntwort.body) : null;
      if (soll == null) throw StateError('Keine gültige Prüfsumme');

      final antwort = await c.send(http.Request('GET', Uri.parse(paketUrl)));
      if (antwort.statusCode != 200) throw StateError('Download fehlgeschlagen (${antwort.statusCode})');
      final gesamt = antwort.contentLength ?? 0;
      var geladen = 0;
      final senke = zip.openWrite();
      await for (final teil in antwort.stream) {
        senke.add(teil);
        geladen += teil.length;
        if (gesamt > 0) fortschritt.value = geladen / gesamt * 0.9;
      }
      await senke.close();

      final ist = (await sha256.bind(zip.openRead()).first).toString();
      if (ist != soll) throw StateError('Prüfsumme stimmt nicht');
      await installieren(zip.path, o);
      fortschritt.value = 1;
      stand.value++;
    } finally {
      if (zip.existsSync()) zip.deleteSync();
      fortschritt.value = null;
      if (client == null) c.close();
    }
  }

  /// Entpackt [zipPfad] nach [ziel]: erst in einen Zwischenordner, dann in einem Schritt austauschen.
  /// Einträge, die aus dem Ordner ausbrechen würden (absolute Pfade, „..“), führen zum Abbruch.
  @visibleForTesting
  static Future<void> installieren(String zipPfad, String ziel) async {
    final neu = Directory('$ziel.neu');
    if (neu.existsSync()) neu.deleteSync(recursive: true);
    neu.createSync(recursive: true);
    final eingabe = InputFileStream(zipPfad);
    try {
      final archiv = ZipDecoder().decodeStream(eingabe);
      for (final eintrag in archiv) {
        if (!eintrag.isFile) continue;
        final name = eintrag.name.replaceAll('\\', '/');
        if (name.startsWith('/') || name.split('/').contains('..') || name.contains(':')) {
          throw StateError('Ungültiger Eintrag im Paket: $name');
        }
        final datei = File('${neu.path}/$name');
        datei.parent.createSync(recursive: true);
        datei.writeAsBytesSync(eintrag.readBytes() ?? const []);
      }
    } catch (_) {
      neu.deleteSync(recursive: true);
      rethrow;
    } finally {
      await eingabe.close();
    }
    if (!File('${neu.path}/audio/version.txt').existsSync()) {
      neu.deleteSync(recursive: true);
      throw StateError('Paket unvollständig');
    }
    final alt = Directory(ziel);
    if (alt.existsSync()) alt.deleteSync(recursive: true);
    neu.renameSync(ziel);
  }

  static Future<void> loeschen() async {
    final o = _ordner;
    if (o != null && Directory(o).existsSync()) Directory(o).deleteSync(recursive: true);
    stand.value++;
  }

  /// Belegter Platz in MB (für die Anzeige), 0 wenn nicht installiert.
  static int get belegtMb {
    final o = _ordner;
    if (o == null || !Directory(o).existsSync()) return 0;
    var bytes = 0;
    for (final f in Directory(o).listSync(recursive: true)) {
      if (f is File) bytes += f.lengthSync();
    }
    return (bytes / 1e6).round();
  }

  /// Nur für Tests: anderen Ordner verwenden.
  @visibleForTesting
  static set ordnerFuerTest(String? pfad) => _ordner = pfad;
}
