/// Feste Anlaufstellen für den Hilfe-Teil von SOS (bleiben in der App, kein Paket).
/// Nummern und Zeiten stammen aus den Quellen in docs/konzepte/sos-neu.md. Vor jedem Release prüfen,
/// danach [sosAnlaufstellenStand] anpassen. Namen und Hinweise stehen in den ARB-Dateien (Schlüssel `sosStelle…`).
library;

const String sosAnlaufstellenStand = '11/2026';

enum SosLand { de, at, ch, uk, us }

class SosStelle {
  final SosLand land;
  final String id;

  /// Wie die Nummer angezeigt wird.
  final String anzeige;

  /// Nur Ziffern (und +), für den Anruf.
  final String tel;
  final String? web;

  const SosStelle(this.land, this.id, this.anzeige, this.tel, {this.web});
}

/// Nummer für den Notruf je Land (nur Ziffern); der Text steht in der ARB (`sosNotruf…`).
const Map<SosLand, String> sosNotrufTel = {
  SosLand.de: '110',
  SosLand.at: '133',
  SosLand.ch: '117',
  SosLand.uk: '999',
  SosLand.us: '911',
};

const List<SosStelle> sosStellen = [
  SosStelle(SosLand.de, 'DeFrauen', '116 016', '116016', web: 'https://www.hilfetelefon.de'),
  SosStelle(SosLand.de, 'DeMaenner', '0800 123 99 00', '08001239900', web: 'https://www.maennerhilfetelefon.de'),
  SosStelle(SosLand.de, 'DeWeisser', '116 006', '116006', web: 'https://weisser-ring.de'),
  SosStelle(SosLand.de, 'DeSeelsorge', '0800 111 0 111', '08001110111', web: 'https://online.telefonseelsorge.de'),
  SosStelle(SosLand.at, 'AtFrauen', '0800 222 555', '0800222555'),
  SosStelle(SosLand.at, 'AtGewaltschutz', '0800 700 217', '0800700217'),
  SosStelle(SosLand.ch, 'ChOpferhilfe', '142', '142', web: 'https://www.opferhilfe-schweiz.ch'),
  SosStelle(SosLand.uk, 'UkRape', '0808 500 2222', '08085002222', web: 'https://247sexualabusesupport.org.uk'),
  SosStelle(SosLand.us, 'UsRainn', '800.656.HOPE (4673)', '8006564673', web: 'https://online.rainn.org'),
  SosStelle(SosLand.us, 'Us988', '988', '988'),
];
