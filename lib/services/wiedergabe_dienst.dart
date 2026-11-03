import 'dart:async';
import 'package:audio_session/audio_session.dart' hide AndroidAudioFocus;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import '../models/bedien_daten.dart';
import '../models/wiedergabe_plan.dart';
import '../l10n/t.dart';
import 'audio_ausgabe.dart';
import 'storage_service.dart';
import 'testmodus.dart';
import 'wach_halten.dart';
import 'wiedergabe_ausgabe.dart';
import 'wiedergabe_lauf.dart';
import 'wiedergabe_plaene.dart';

class WiedergabeDienst with WidgetsBindingObserver {
  static final instanz = WiedergabeDienst._();
  WiedergabeDienst._() {
    lauf = WiedergabeLauf(
        ausgabe: nativeAbschnittAusgabe,
        wach: _wach,
        sichern: _sichern,
        begleiten: _begleiten,
        abschnittBeginnt: _abschnittBeginnt);
    lauf.addListener(_aktualisieren);
  }
  late final WiedergabeLauf lauf;
  static const _kanal = MethodChannel('velvetpulse/wiedergabe');
  Future<void>? _initialisierung;
  bool _wachAn = false, _fokus = false;
  AudioPlayer? _teppich;
  bool _teppichAn = false, _teppichPause = false;
  AudioSession? _session;
  DateTime _letzteMeldung = DateTime(0);
  bool? _zuletztSpielend;
  bool _systemBegonnen = false;
  bool _gemeinsamVorbereitet = false;
  bool? _zuletztSystemAktiv;
  Future<void> _begleitArbeit = Future.value();
  Future<void> Function()? gemeinsamPause;
  Future<void> Function()? gemeinsamWeiter;
  Future<void> Function()? gemeinsamBeenden;
  Future<void> Function()? vorNeustart;

  Future<void> initialisieren() => _initialisierung ??= _init();
  Future<void> _init() async {
    WidgetsBinding.instance.addObserver(this);
    StorageService.spicyAenderung.addListener(_modus);
    await AudioAusgabe.instanz.initialisieren();
    AudioAusgabe.instanz.onKopfhoererGetrennt.listen((_) {
      if (StorageService.getPausiereBeiKopfhoererGetrennt() && lauf.spielt)
        unawaited(pause());
    });
    try {
      _session = await AudioSession.instance;
      await _session!.configure(const AudioSessionConfiguration.speech());
      _session!.interruptionEventStream.listen((e) {
        // Telefonat, andere Wiedergabe: niemals ungefragt wieder anlaufen.
        if (e.begin && lauf.spielt) unawaited(pause());
      });
    } catch (_) {}
    _kanal.setMethodCallHandler((call) async {
      if (call.method == 'pause') await pause();
      if (call.method == 'weiter') {
        // Wiederanlauf aus der Systemanzeige nur nach geöffneter App und
        // Lautsprecherprüfung; neutraler Hinweis, keine automatische Ausgabe.
        return;
      }
      if (call.method == 'beenden') await beenden();
    });
    await wiederfinden();
  }

  Future<void> wiederfinden() async {
    if (lauf.plan != null) return;
    final merker = StorageService.getBedienDaten().wiedergabe;
    if (merker?.plan == null) return;
    try {
      final plan = await WiedergabePlaene.ergaenzen(merker!.plan!);
      await lauf.vormerken(plan, merker.index, merker.position);
    } catch (_) {
      // Ein fehlendes privates Textpaket löscht/versteckt den Merker nicht:
      // neutral wiederfinden und Laden anbieten, aber niemals ungeprüft starten.
      final p = merker!.plan!;
      if ((p.art == WiedergabeArt.reihe ||
              p.art == WiedergabeArt.lust ||
              p.art == WiedergabeArt.praxis) &&
          StorageService.spicyMode()) {
        final neutral = WiedergabePlan(
            art: p.art,
            id: p.id,
            sprache: p.sprache,
            spicy: true,
            titel: t.wiedergabeNeutral,
            abschnitte: p.abschnitte,
            parameter: p.parameter);
        await lauf.vormerken(neutral, merker.index, merker.position);
      }
    }
  }

  void _modus() {
    if (!StorageService.spicyMode() && lauf.plan?.spicy == true) {
      unawaited(beenden());
    } else if (lauf.plan == null) {
      unawaited(wiederfinden());
    }
  }

  Future<void> starten(WiedergabePlan plan) async {
    await initialisieren();
    final validiert = await WiedergabePlaene.ergaenzen(plan);
    await vorNeustart?.call();
    await lauf.starten(validiert);
  }

  Future<void> pause() => gemeinsamPause?.call() ?? lauf.pause();
  Future<void> weiter() async {
    if (lauf.plan?.spicy == true && !StorageService.spicyMode())
      return Future.value();
    if (lauf.plan == null) return;
    try {
      lauf.plan = await WiedergabePlaene.ergaenzen(lauf.plan!);
    } catch (e) {
      await lauf.meldeFehler(e);
      return;
    }
    return gemeinsamWeiter?.call() ?? lauf.wiederaufnehmen();
  }

  Future<void> beenden({bool entfernen = false}) async {
    await gemeinsamBeenden?.call();
    await lauf.beenden(entfernen: entfernen);
  }

  /// Bereitschaft ist eine bewusste Aktion in der geöffneten App. Den neutralen
  /// Mediendienst dabei starten, statt erst nach dem Countdown im Hintergrund.
  void gemeinsamVorbereitet(bool bereit) {
    _gemeinsamVorbereitet = bereit;
    _aktualisieren();
  }

  Future<void> _wach(bool an) async {
    if (an && !_wachAn) {
      _wachAn = true;
      await WachHalten.halten();
    }
    if (!an && _wachAn) {
      _wachAn = false;
      await WachHalten.freigeben();
    }
    if (_fokus != an) {
      _fokus = an;
      try {
        final erlaubt = await _session?.setActive(an);
        if (an && erlaubt == false)
          throw StateError('Audio-Fokus nicht verfügbar');
      } on MissingPluginException catch (_) {}
    }
  }

  Future<void> _sichern(WiedergabeLauf l, bool backup) async {
    final plan = l.plan;
    if (plan == null) return;
    final geloescht = l.zustand == WiedergabeZustand.fertig;
    final merker = WiedergabeMerker(
        plan: geloescht ? null : plan,
        index: geloescht ? 0 : l.index,
        position: geloescht ? Duration.zero : l.aufnahmePosition,
        geaendert: DateTime.now());
    await StorageService.saveBedienDaten(BedienDaten(wiedergabe: merker),
        backup: backup);
  }

  Future<void> _abschnittBeginnt(WiedergabeLauf l) async {
    final p = l.plan!;
    final folge = p.parameter['lustFolge'];
    if (!l.spielt ||
        Testmodus.an ||
        folge is! int ||
        p.parameter['lustZaehlen'] != true ||
        !l.abschnitt!.id.startsWith('f${folge}_')) return;
    await StorageService.lustAbendGehoert(folge);
    l.plan = WiedergabePlan(
        art: p.art,
        id: p.id,
        sprache: p.sprache,
        spicy: p.spicy,
        titel: p.titel,
        abschnitte: p.abschnitte,
        parameter: {...p.parameter, 'lustZaehlen': false});
  }

  Future<void> _begleiten(WiedergabeLauf l) {
    final job = _begleitArbeit.then((_) => _begleitung(l));
    _begleitArbeit =
        job.then<void>((_) {}, onError: (Object _, StackTrace __) {});
    return job;
  }

  Future<void> _begleitung(WiedergabeLauf l) async {
    final p = l.plan;
    if (p != null && l.spielt) {
      final von = (p.parameter['stimmeVon'] as num? ?? 1).toDouble();
      final bis = (p.parameter['stimmeBis'] as num? ?? von).toDouble();
      final anteil = l.dauer > Duration.zero
          ? (l.vergangen.inMilliseconds / l.dauer.inMilliseconds)
              .clamp(0.0, 1.0)
          : 0.0;
      await l.laut((von + (bis - von) * anteil).clamp(0.0, 1.0));
    }
    final soll = p?.parameter['teppich'] == true;
    if (!soll || !l.vorhanden || l.zustand == WiedergabeZustand.fehler) {
      if (_teppichAn) {
        await _teppich?.stop();
        _teppichAn = false;
      }
      return;
    }
    if (!l.spielt) {
      if (_teppichAn && !_teppichPause) {
        await _teppich?.pause();
        _teppichPause = true;
      }
      return;
    }
    if (_teppich == null) {
      _teppich = AudioPlayer();
      await _teppich!.setAudioContext(AudioContext(
          android:
              const AudioContextAndroid(audioFocus: AndroidAudioFocus.none)));
      await _teppich!.setReleaseMode(ReleaseMode.loop);
    }
    var laut = (p!.parameter['teppichLaut'] as num? ?? 0.3).toDouble();
    final blendeMs = (p.parameter['blendeMs'] as num? ?? 0).toInt();
    if (l.index == p.abschnitte.length - 1 && blendeMs > 0) {
      final d = l.abschnitt!.dauer.inMilliseconds;
      final blende = blendeMs.clamp(1, d);
      final rest = (d - l.position.inMilliseconds) / blende;
      laut *= rest.clamp(0.0, 1.0);
    }
    await _teppich!.setVolume(laut.clamp(0.0, 1.0));
    if (!_teppichAn) {
      await _teppich!.play(AssetSource('audio/paar/klangteppich.opus'));
      _teppichAn = true;
      _teppichPause = false;
    } else if (_teppichPause) {
      await _teppich!.resume();
      _teppichPause = false;
    }
  }

  void _aktualisieren() {
    if (lauf.spielt) _systemBegonnen = true;
    if (!lauf.vorbereitet && !lauf.spielt) _systemBegonnen = false;
    final jetzt = DateTime.now();
    final systemAktiv =
        lauf.vorhanden && (_systemBegonnen || _gemeinsamVorbereitet);
    if (_zuletztSpielend == lauf.spielt &&
        _zuletztSystemAktiv == systemAktiv &&
        jetzt.difference(_letzteMeldung).inSeconds < 1) return;
    _zuletztSystemAktiv = systemAktiv;
    _zuletztSpielend = lauf.spielt;
    _letzteMeldung = jetzt;
    unawaited(_kanal.invokeMethod<void>('zustand', {
      'aktiv': systemAktiv,
      'spielt': lauf.spielt,
      'titel': t.wiedergabeNeutral,
      'pause': t.playerSteuerungPause,
      'beenden': t.playerSteuerungStop,
      'position': lauf.vergangen.inMilliseconds,
      'dauer': lauf.dauer.inMilliseconds,
    }).catchError((Object _) {}));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached)
      unawaited(_sichern(lauf, true).catchError((Object _) {}));
  }
}
