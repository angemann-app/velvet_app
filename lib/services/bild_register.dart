import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../theme/vp_tokens.dart';
import 'pakete.dart';
import 'sprache.dart';
import 'storage_service.dart';

/// Ein Eintrag im Bildregister (`assets/data/bilder.json`, gebaut von `tools/bilder_register.py`).
@immutable
class BildEintrag {
  final String id;
  final VpBildFormat format;

  /// Reguläres Bild in der APK (`assets/…`) oder, bei [paket], eine Datei aus einem Paket.
  final String normal;

  /// Fassung für den Spicy-Modus, falls vorhanden.
  final String? spicy;

  /// Englische Fassung (nur bei Bildern mit Beschriftung).
  final String? englisch;

  /// Paketname, wenn das Bild nicht in der APK liegt (`Pakete.datei`).
  final String? paket;

  final String altDe;
  final String altEn;

  const BildEintrag({
    required this.id,
    required this.format,
    required this.normal,
    this.spicy,
    this.englisch,
    this.paket,
    required this.altDe,
    required this.altEn,
  });

  factory BildEintrag.aus(String id, Map<String, dynamic> j) {
    final alt = (j['alt'] as Map?) ?? const {};
    return BildEintrag(
      id: id,
      format: VpBildFormat.ausName(j['format'] as String?) ?? VpBildFormat.kopf,
      normal: j['normal'] as String,
      spicy: j['spicy'] as String?,
      englisch: j['englisch'] as String?,
      paket: j['paket'] as String?,
      altDe: (alt['de'] as String?) ?? '',
      altEn: (alt['en'] as String?) ?? '',
    );
  }

  String alt(bool englisch) => englisch ? altEn : altDe;
}

/// Wo ein Bild herkommt: Asset in der APK oder Datei auf dem Gerät (Paket).
@immutable
class BildQuelle {
  final String pfad;
  final bool istDatei;
  const BildQuelle.asset(this.pfad) : istDatei = false;
  const BildQuelle.datei(this.pfad) : istDatei = true;

  bool get istSvg => pfad.toLowerCase().endsWith('.svg');
}

/// Zentrale Bildverwaltung. Bildschirme nennen eine ID (oder, für Bestandsinhalte, den Pfad aus den Inhaltsdateien),
/// nie die Fassung: Spicy, Sprache und Paket löst das Register auf.
///
/// Reihenfolge: Spicy-Fassung (Modus an und Datei da) → reguläres Bild → `null` (dann zeichnet `VpBildFeld` den Platzhalter).
class BildRegister {
  static final Map<String, BildEintrag> _nachId = {};
  static final Map<String, BildEintrag> _nachPfad = {};
  static final Set<String> _grafik = {};
  static bool _geladen = false;

  static Future<void> laden({String pfad = 'assets/data/bilder.json'}) async {
    ladenAusText(await rootBundle.loadString(pfad));
  }

  /// Auch für Tests mit eigenem Inhalt.
  @visibleForTesting
  static void ladenAusText(String text) {
    final j = jsonDecode(text) as Map<String, dynamic>;
    _nachId.clear();
    _nachPfad.clear();
    _grafik
      ..clear()
      ..addAll(((j['grafik'] as Map?) ?? const {}).keys.cast<String>());
    for (final e in ((j['bilder'] as Map?) ?? const {}).entries) {
      final eintrag = BildEintrag.aus(e.key as String, Map<String, dynamic>.from(e.value as Map));
      _nachId[eintrag.id] = eintrag;
      _nachPfad[eintrag.normal] = eintrag;
    }
    _geladen = true;
  }

  static bool get geladen => _geladen;
  static Iterable<BildEintrag> get alle => _nachId.values;
  static Set<String> get grafikIds => _grafik;

  static BildEintrag? eintrag(String id) => _nachId[id];

  /// Eintrag zu einem Bestandspfad aus den Inhaltsdateien (`assets/images/cover_01.svg`).
  static BildEintrag? nachPfad(String pfad) => _nachPfad[pfad];

  /// Die Quelle, die jetzt gelten soll. `null`, wenn es kein passendes Bild gibt.
  static BildQuelle? loese(BildEintrag e, {bool? spicy, bool? englisch}) {
    final sp = spicy ?? StorageService.spicyMode();
    final en = englisch ?? Sprache.englisch;
    if (sp && e.spicy != null) return _quelle(e.spicy!, e.paket);
    if (en && e.englisch != null) return _quelle(e.englisch!, e.paket);
    return _quelle(e.normal, e.paket);
  }

  static BildQuelle? _quelle(String pfad, String? paket) {
    if (paket == null) return BildQuelle.asset(pfad);
    final datei = Pakete.datei(pfad);
    return datei == null ? null : BildQuelle.datei(datei);
  }
}
