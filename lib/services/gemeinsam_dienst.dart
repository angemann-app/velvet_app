import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import '../models/wiedergabe_plan.dart';
import 'gemeinsam_hoeren.dart';
import 'nostr_service.dart';
import 'pakete.dart';
import 'storage_service.dart';
import 'wiedergabe_dienst.dart';
import 'wiedergabe_plaene.dart';
import 'wach_halten.dart';

/// Bindet ausschließlich die bereits geprüften Partnersignale an die Sitzung.
class GemeinsamDienst {
  static final instanz = GemeinsamDienst._();
  late final GemeinsamHoeren hoeren;
  bool _countdownWach = false;
  GemeinsamDienst._() {
    final n = NostrService(), w = WiedergabeDienst.instanz;
    hoeren = GemeinsamHoeren(
        lauf: w.lauf,
        signale: n.signale,
        sende: n.sendSignal,
        ergaenzen: WiedergabePlaene.ergaenzen,
        pruefsumme: aufnahmenPruefen,
        gekoppelt: () => n.isPaired,
        spicy: StorageService.spicyMode);
    w.gemeinsamPause = () =>
        hoeren.aktiv && (hoeren.angenommen || hoeren.gastgeber)
            ? hoeren.pause()
            : w.lauf.pause();
    w.gemeinsamWeiter = () =>
        hoeren.aktiv && (hoeren.angenommen || hoeren.gastgeber)
            ? hoeren.bereit()
            : w.lauf.wiederaufnehmen();
    w.gemeinsamBeenden = () async {
      if (hoeren.aktiv) await hoeren.beenden();
    };
    w.vorNeustart = () async {
      if (hoeren.aktiv) await hoeren.beenden();
    };
    hoeren.addListener(() {
      w.gemeinsamVorbereitet(hoeren.aktiv && hoeren.ichBereit);
      final countdown = hoeren.phase == GemeinsamPhase.countdown;
      if (countdown && !_countdownWach) {
        _countdownWach = true;
        WachHalten.halten();
      } else if (!countdown && _countdownWach) {
        _countdownWach = false;
        WachHalten.freigeben();
      }
    });
    StorageService.spicyAenderung.addListener(() {
      if (hoeren.aktiv &&
          hoeren.plan?.spicy == true &&
          !StorageService.spicyMode()) hoeren.beenden();
    });
  }

  /// Beide Geräte vergleichen tatsächliche Dateiinhalte, Sprache und Ablauf.
  /// Unterschiedliche Paketversionen sind erlaubt, wenn die Aufnahme identisch
  /// ist; fehlende/abweichende Dateien führen nie zur Geräte-Stimme.
  static Future<String?> aufnahmenPruefen(WiedergabePlan p) async {
    try {
      final hashes = <String, String>{};
      for (final s in p.abschnitte) {
        if (s.pfad == null || hashes.containsKey(s.pfad)) continue;
        if (s.art == AbschnittArt.klang) {
          final b = await rootBundle.load('assets/audio/paar/klangschale.opus');
          hashes[s.pfad!] = sha256
              .convert(b.buffer.asUint8List(b.offsetInBytes, b.lengthInBytes))
              .toString();
        } else {
          final pfad = Pakete.datei(s.pfad!, sprache: p.sprache);
          if (pfad == null || await File(pfad).length() == 0) return null;
          hashes[s.pfad!] =
              (await sha256.bind(File(pfad).openRead()).first).toString();
        }
      }
      if (hashes.isEmpty) return null;
      final form = {
        'sprache': p.sprache,
        'art': p.art.name,
        'id': p.id,
        'abschnitte': [for (final s in p.abschnitte) s.toJson()],
        'dateien': hashes
      };
      return sha256.convert(utf8.encode(jsonEncode(form))).toString();
    } catch (_) {
      return null;
    }
  }
}
