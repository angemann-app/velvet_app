import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import '../models/content_models.dart';
import '../models/paar_abend.dart';
import '../models/lust_reihe.dart';
import '../models/traumpraxis_hoeren.dart';
import '../models/wiedergabe_plan.dart';
import 'pakete.dart';
import 'personalize.dart';
import 'sprache.dart';
import 'storage_service.dart';
import '../l10n/t.dart';

class WiedergabePlaene {
  static List<String> paketNamen(WiedergabePlan p) {
    final arten = <String>{};
    for (final s in p.abschnitte) {
      if (s.art != AbschnittArt.sprache || s.pfad == null) continue;
      final teile = s.pfad!.split('/');
      arten.add(teile.length == 2
          ? Pakete.lektionen
          : teile[1] == 'lust'
              ? Pakete.lust
              : teile[1] == 'reihe'
                  ? Pakete.reihe
                  : Pakete.gefuehrt);
    }
    return [for (final art in arten) Pakete.name(art, p.sprache)];
  }

  static WiedergabePlan schritte(
          {required WiedergabeArt art,
          required String titel,
          required List<PaarSchritt> schritte,
          required String stimme,
          required String Function(String) familie,
          required bool spicy,
          Map<String, Object> parameter = const {}}) =>
      WiedergabePlan(
          art: art,
          id: art.name,
          sprache: Sprache.code,
          spicy: spicy,
          titel: titel,
          parameter: {
            'stimme': stimme,
            ...parameter
          },
          abschnitte: [
            for (var i = 0; i < schritte.length; i++)
              WiedergabeAbschnitt(
                  id: schritte[i].baustein?.id ?? 'stille_$i',
                  art: schritte[i].klang
                      ? AbschnittArt.klang
                      : schritte[i].baustein == null
                          ? AbschnittArt.stille
                          : AbschnittArt.sprache,
                  dauer: schritte[i].dauer,
                  runde: schritte[i].runde,
                  phase: schritte[i].baustein?.phase ?? '',
                  pfad: schritte[i].klang
                      ? 'audio/paar/klangschale.opus'
                      : schritte[i].baustein == null
                          ? null
                          : 'audio/${familie(schritte[i].baustein!.id)}/${stimme}_${schritte[i].baustein!.id}.opus',
                  text: schritte[i].baustein?.text ?? '')
          ]);

  static WiedergabePlan reihe(
          ReiheDaten daten, ReiheFolge folge, ReiheFassung f) =>
      WiedergabePlan(
          art: WiedergabeArt.reihe,
          id: folge.id,
          sprache: Sprache.code,
          spicy: true,
          titel: folge.titel,
          parameter: {
            'folge': folge.id,
            'variante': f.id,
            'stimme': f.stimme,
            // Drei Rollen, aber zwei Geräte: Dreier-Folgen werden nur allein gehört.
            if (folge.typ == 'trio') 'trio': true
          },
          abschnitte: [
            for (final s in f.segmente)
              WiedergabeAbschnitt(
                  id: s.szene,
                  art: AbschnittArt.sprache,
                  dauer: daten.dauerVon(folge, f, s),
                  pfad: ReiheDaten.audioPfad(folge, f, s),
                  text: s.text,
                  bild: ReiheDaten.bildPfad(folge, f, s),
                  aufnahmeEnde: true)
          ]);

  /// Eine einzeln gestartete Traumpraxis-Begleitung (nur Spicy). Dauer und Pfad stammen aus dem Katalog.
  static WiedergabePlan praxis(PraxisBegleitung b, String stimme) {
    final a = b.aufnahmen[stimme];
    if (a == null) throw StateError('Stimme fehlt');
    return WiedergabePlan(
        art: WiedergabeArt.praxis,
        id: b.id,
        sprache: Sprache.code,
        spicy: true,
        titel: b.titel,
        parameter: {'stimme': stimme},
        abschnitte: [
          WiedergabeAbschnitt(
              id: b.id,
              art: AbschnittArt.sprache,
              dauer: Duration(milliseconds: a.dauerMs),
              phase: b.phase,
              pfad: a.pfad,
              text: b.text,
              aufnahmeEnde: true)
        ]);
  }

  static Future<Map<String, dynamic>> _json(String name, String sprache) async {
    final pfad = '${sprache == 'en' ? 'translations/en' : 'assets/data'}/$name';
    return jsonDecode(await rootBundle.loadString(pfad))
        as Map<String, dynamic>;
  }

  /// Merker und Einladungen enthalten keine Texte. Ausschließlich kanonische
  /// lokale Inhalte ergänzen; damit lässt sich das Spicy-Gate nicht durch ein
  /// gefälschtes `spicy: false` oder einen fremden Aufnahmepfad umgehen.
  static Future<WiedergabePlan> ergaenzen(WiedergabePlan plan) async {
    var spicy = plan.spicy;
    var titel = plan.titel;
    if (titel.isEmpty)
      titel = switch (plan.art) {
        WiedergabeArt.paar => t.couplesChannelSharedEvening,
        WiedergabeArt.selbst => t.lessonDetailGuidedSelfExploration,
        WiedergabeArt.einschlaf => t.einschlafTitel,
        WiedergabeArt.traum => t.traumTitel,
        WiedergabeArt.wecken => t.weckenBegleitungTitel,
        WiedergabeArt.lust => t.lustTitel,
        _ => t.wiedergabeNeutral,
      };
    final texte = <String, String>{};
    final erlaubtePfade = <String>{};
    if (plan.art == WiedergabeArt.lektion) {
      final db = VelvetDatabase.fromJson(
          await _json('velvet_content.json', plan.sprache));
      Course? kurs;
      Lesson? lektion;
      for (final c in db.alleKurse) {
        for (final l in c.lessons) {
          if (l.id == plan.id) {
            kurs = c;
            lektion = l;
          }
        }
      }
      if (lektion == null || plan.abschnitte.length != 1)
        throw StateError('Lektion fehlt');
      spicy |= kurs!.spicy || lektion.spicy;
      titel = lektion.title;
      final pfad = 'audio/${lektion.id}.opus';
      erlaubtePfade.add(pfad);
      texte[pfad] = stripPersonalization(lektion.content);
    } else if (plan.art == WiedergabeArt.praxis) {
      // Gate immer aus dem Katalog, nie aus dem gespeicherten oder empfangenen Plan.
      spicy = true;
      final katalog = await PraxisBegleitung.laden(sprache: plan.sprache);
      if (katalog == null) throw StateError('Traumpraxis-Paket fehlt');
      final b = katalog.where((e) => e.id == plan.id).firstOrNull;
      final stimme = plan.parameter['stimme'];
      if (b == null ||
          stimme is! String ||
          !b.aufnahmen.containsKey(stimme) ||
          plan.abschnitte.length != 1) {
        throw StateError('Begleitung unbekannt');
      }
      final pfad = b.aufnahmen[stimme]!.pfad;
      if (plan.abschnitte.first.pfad != pfad) {
        throw StateError('Aufnahme gehört nicht zum Inhalt');
      }
      titel = b.titel;
      erlaubtePfade.add(pfad);
      texte[pfad] = b.text;
    } else if (plan.art == WiedergabeArt.reihe) {
      spicy = true;
      final datei = Pakete.datei('reihe/reihe.json', sprache: plan.sprache);
      if (datei == null) throw StateError('Reihenpaket fehlt');
      final daten =
          ReiheDaten.fromJson(jsonDecode(await File(datei).readAsString()));
      final folge = daten.folgen.where((f) => f.id == plan.id).firstOrNull;
      final fassung = folge?.fassungen
          .where((f) => f.id == plan.parameter['variante'])
          .firstOrNull;
      if (folge == null ||
          fassung == null ||
          fassung.segmente.length != plan.abschnitte.length) {
        throw StateError('Fassung fehlt');
      }
      titel = folge.titel;
      for (var i = 0; i < fassung.segmente.length; i++) {
        final s = fassung.segmente[i];
        final pfad = ReiheDaten.audioPfad(folge, fassung, s);
        if (plan.abschnitte[i].id != s.szene ||
            plan.abschnitte[i].pfad != pfad ||
            plan.abschnitte[i].bild != ReiheDaten.bildPfad(folge, fassung, s)) {
          throw StateError('Szenenfolge stimmt nicht');
        }
        erlaubtePfade.add(pfad);
        texte[pfad] = s.text;
      }
    } else {
      final familien = switch (plan.art) {
        WiedergabeArt.paar => ['paar'],
        WiedergabeArt.selbst => ['selbst'],
        WiedergabeArt.einschlaf => ['einschlaf'],
        WiedergabeArt.traum => ['einschlaf', 'traum'],
        WiedergabeArt.wecken => ['traum'],
        WiedergabeArt.lust => ['einschlaf', 'traum', 'lust'],
        _ => <String>[],
      };
      final stimme = plan.parameter['stimme'];
      if (stimme != 'martin' && stimme != 'victoria')
        throw StateError('Stimme fehlt');
      if (plan.art == WiedergabeArt.lust) spicy = true;
      for (final familie in familien) {
        Map<String, dynamic> j;
        if (familie == 'lust') {
          final datei = Pakete.datei('lust/lust.json', sprache: plan.sprache);
          if (datei == null) throw StateError('Inhaltspaket fehlt');
          j = jsonDecode(await File(datei).readAsString());
        } else {
          j = await _json(
              '${familie == 'paar' ? 'paar_abend' : '${familie}_reise'}.json',
              plan.sprache);
        }
        for (final b in j['bausteine'] as List) {
          final pfad = 'audio/$familie/${stimme}_${b['id']}.opus';
          erlaubtePfade.add(pfad);
          texte[pfad] = b['text'] as String;
          if (plan.abschnitte.any((s) => s.pfad == pfad) &&
              (b['spicy'] == true ||
                  b['tiefe'] == 'spicy' ||
                  b['tiefe'] == 'sehrSpicy')) spicy = true;
        }
      }
    }
    if (spicy && !StorageService.spicyMode())
      throw StateError('Modus nicht freigegeben');
    final schritte = <WiedergabeAbschnitt>[];
    for (final s in plan.abschnitte) {
      if (s.art == AbschnittArt.sprache && !erlaubtePfade.contains(s.pfad)) {
        throw StateError('Aufnahme gehört nicht zum Inhalt');
      }
      if (s.art == AbschnittArt.klang &&
          s.pfad != 'audio/paar/klangschale.opus') {
        throw StateError('Unbekannter Klang');
      }
      schritte.add(WiedergabeAbschnitt(
          id: s.id,
          art: s.art,
          dauer: s.dauer,
          pfad: s.pfad,
          text: texte[s.pfad] ?? '',
          phase: s.phase,
          runde: s.runde,
          aufnahmeEnde: s.aufnahmeEnde,
          bild: s.bild));
    }
    return WiedergabePlan(
        art: plan.art,
        id: plan.id,
        sprache: plan.sprache,
        spicy: spicy,
        titel: titel,
        abschnitte: schritte,
        parameter: plan.parameter);
  }
}
