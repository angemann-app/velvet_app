import '../services/sprache.dart';
import 'app_localizations.dart';

export 'app_localizations.dart';

/// Kurzer Zugriff auf die Oberflächentexte der aktuellen Sprache, auch ohne BuildContext:
/// `Text(t.sprachTitel)`. Bei einem Sprachwechsel baut main.dart die ganze App neu auf.
AppLocalizations get t => Sprache.texte;
