import 'dart:convert';
import 'dart:io';

import 'package:cryptography/cryptography.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Ein Paket im Verzeichnis, z. B. das englische Audiopaket oder später die Traum-Reise.
class PaketEintrag {
  final String name;
  final String sprache;
  final int version;
  final int groesse;
  final String sha256;

  /// Download-Adressen in Reihenfolge; die App nimmt die erste, die antwortet, und prüft immer SHA-256.
  final List<String> adressen;

  /// Nur im Spicy-Modus sichtbar und ladbar.
  final bool spicy;

  const PaketEintrag({
    required this.name,
    required this.sprache,
    required this.version,
    required this.groesse,
    required this.sha256,
    required this.adressen,
    this.spicy = false,
  });

  static PaketEintrag ausJson(Map<String, dynamic> j) {
    final adressen = (j['adressen'] as List).cast<String>();
    final sha = j['sha256'] as String;
    if (!RegExp(r'^[0-9a-f]{64}$').hasMatch(sha)) throw const FormatException('sha256 ungültig');
    if (adressen.isEmpty || adressen.any((a) => !a.startsWith('https://'))) {
      throw const FormatException('Adressen müssen https sein');
    }
    return PaketEintrag(
      name: j['name'] as String,
      sprache: j['sprache'] as String,
      version: j['version'] as int,
      groesse: j['groesse'] as int,
      sha256: sha,
      adressen: adressen,
      spicy: j['spicy'] == true,
    );
  }
}

/// Signiertes Paket-Verzeichnis (`audio-index.json` und `audio-index.json.sig`).
///
/// Die App kennt nur die Adressen dieses Verzeichnisses. Es listet alle Pakete mit Version, Größe, SHA-256 und
/// Download-Adressen. So kommen neue Pakete und korrigierte Aufnahmen ohne App-Update, und die Pakete können
/// umziehen (R2, GitHub, eigener Server), ohne dass jemand fremde Dateien unterschieben kann:
/// - Die Signatur (Ed25519 über die Bytes der JSON-Datei) wird mit dem fest eingebauten [pruefschluessel]
///   geprüft, nie mit einem Schlüssel aus dem Netz.
/// - Die [laufnummer] steigt mit jeder Veröffentlichung. Die App merkt sich die höchste angenommene und lehnt
///   kleinere ab, auch wenn sie gültig signiert sind: kein Zurückrollen auf alte Pakete.
/// Konzept: docs/konzepte/traum-reise.md, „Audio: Bausteine und Pakete“. Werkzeuge: tools/paket_*.dart.
class PaketVerzeichnis {
  /// Öffentlicher Ed25519-Schlüssel (privater nur in C:\TOOLS\velvet-pakete\, tools/paket_schluessel.dart).
  static const pruefschluessel = '9AJqpV06oOrAiH5hRx4nao6A/d+7tp4zAy38g8Rg8ug=';

  /// Formatversion, die diese App versteht.
  static const format = 1;

  /// Wo das Verzeichnis liegt, in Reihenfolge. Leere Einträge werden übersprungen.
  static const adressen = [
    // Cloudflare R2 (öffentliche Adresse des Buckets, sobald eingerichtet).
    '',
    'https://github.com/angemann-app/velvet_app/releases/download/pakete/audio-index.json',
  ];

  static const _keyLaufnummer = 'velvet_pakete_laufnummer';

  final int laufnummer;
  final List<PaketEintrag> pakete;

  const PaketVerzeichnis(this.laufnummer, this.pakete);

  PaketEintrag? paket(String name) {
    for (final p in pakete) {
      if (p.name == name) return p;
    }
    return null;
  }

  /// Prüft Signatur und Format und gibt das Verzeichnis zurück. Wirft bei jedem Fehler.
  static Future<PaketVerzeichnis> pruefen(Uint8List json, String signaturBase64, {String? schluessel}) async {
    final ok = await Ed25519().verify(
      json,
      signature: Signature(base64Decode(signaturBase64.trim()),
          publicKey: SimplePublicKey(base64Decode(schluessel ?? pruefschluessel), type: KeyPairType.ed25519)),
    );
    if (!ok) throw const FormatException('Signatur des Paket-Verzeichnisses ungültig');
    final daten = jsonDecode(utf8.decode(json)) as Map<String, dynamic>;
    if (daten['format'] != format) throw FormatException('Unbekanntes Format ${daten['format']}');
    final laufnummer = daten['laufnummer'];
    if (laufnummer is! int || laufnummer < 1) throw const FormatException('Laufnummer fehlt');
    return PaketVerzeichnis(
      laufnummer,
      [for (final p in daten['pakete'] as List) PaketEintrag.ausJson(p as Map<String, dynamic>)],
    );
  }

  static PaketVerzeichnis? _aktuell;

  /// Zuletzt angenommenes Verzeichnis (für Tests zurücksetzbar).
  static PaketVerzeichnis? get aktuell => _aktuell;

  @visibleForTesting
  static void vergessen() => _aktuell = null;

  /// Lädt das Verzeichnis von der ersten Adresse, die ein gültiges liefert. Fällt sonst auf die zuletzt
  /// gespeicherte, gültige Fassung zurück. Gibt null zurück, wenn es keins gibt.
  static Future<PaketVerzeichnis?> laden({
    http.Client? client,
    List<String>? adressenFuerTest,
    String? schluesselFuerTest,
    Future<String> Function()? ablageFuerTest,
  }) async {
    final c = client ?? http.Client();
    try {
      final prefs = await SharedPreferences.getInstance();
      final hoechste = prefs.getInt(_keyLaufnummer) ?? 0;
      final ablage = await (ablageFuerTest ?? _ablage)();
      for (final adresse in adressenFuerTest ?? adressen) {
        if (adresse.isEmpty) continue;
        try {
          final json = await c.get(Uri.parse(adresse)).timeout(const Duration(seconds: 20));
          final sig = await c.get(Uri.parse('$adresse.sig')).timeout(const Duration(seconds: 20));
          if (json.statusCode != 200 || sig.statusCode != 200) continue;
          final v = await pruefen(json.bodyBytes, sig.body, schluessel: schluesselFuerTest);
          if (v.laufnummer < hoechste) {
            debugPrint('Paket-Verzeichnis: ältere Laufnummer ${v.laufnummer} < $hoechste abgelehnt');
            continue;
          }
          await prefs.setInt(_keyLaufnummer, v.laufnummer);
          File('$ablage/audio-index.json').writeAsBytesSync(json.bodyBytes, flush: true);
          File('$ablage/audio-index.json.sig').writeAsStringSync(sig.body, flush: true);
          return _aktuell = v;
        } catch (e) {
          debugPrint('Paket-Verzeichnis: $adresse nicht nutzbar (${e.runtimeType})');
        }
      }
      // Offline oder alle Adressen gestört: die gespeicherte Fassung, erneut geprüft.
      final json = File('$ablage/audio-index.json');
      final sig = File('$ablage/audio-index.json.sig');
      if (json.existsSync() && sig.existsSync()) {
        final v = await pruefen(json.readAsBytesSync(), sig.readAsStringSync(), schluessel: schluesselFuerTest);
        if (v.laufnummer >= hoechste) return _aktuell = v;
      }
      return null;
    } catch (e) {
      debugPrint('Paket-Verzeichnis: nicht verfügbar (${e.runtimeType})');
      return null;
    } finally {
      if (client == null) c.close();
    }
  }

  static Future<String> _ablage() async {
    final d = Directory('${(await getApplicationSupportDirectory()).path}/pakete');
    if (!d.existsSync()) d.createSync(recursive: true);
    return d.path;
  }
}
