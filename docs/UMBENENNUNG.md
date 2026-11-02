# Umbenennung des GitHub-Kontos (Mittwoch, 04.11.2026)

Alter Kontoname: `angemann-app`. **Neuer Name: `lotus-atelier`** (Entscheidung des Nutzers, 02.11.2026). Ziel: „angemann“ ist danach weder im Repository,
im Verlauf noch in der App zu finden (was bereits öffentlich kopiert wurde, etwa in fremden Klonen oder Archiven, lässt sich nicht zurückholen).

## Ausgangslage

- Verbreitung klein: 1 Stern, 0 Forks, je Release 2 bis 8 Downloads, 14 verschiedene Besucher der Seite in 14 Tagen.
- 376 Commits, 53 Tags. Autor und Committer tragen `Angemann` oder `angemann-app <346896525+angemann-app@users.noreply.github.com>`;
  50 Commit-Nachrichten und die Dateien in 14 Stellen des aktuellen Stands nennen den Namen.

## Fallen

1. **Alte Apps sehen nach der Umbenennung keine Updates mehr.** GitHub liefert die Download-Adressen der Release-Dateien mit dem *neuen* Namen,
   die alten Apps lassen aber nur Adressen unter `https://github.com/angemann-app/velvet_app/releases/download/` zu
   (`UpdateService.isReleaseDownloadUrl`). Folge: Wer eine Version vor der Umbenennung hat, holt die erste neue Version **einmal von Hand**
   (Link auf die Releases-Seite). Bei zwei bis drei Geräten ist das einfacher als eine Übergangsversion, die beide Namen kennt.
2. **Die Weiterleitung des alten Namens endet,** sobald jemand den alten Namen registriert. Darauf nicht verlassen.
3. **Der Verlauf trägt den Namen** (Autor, Committer, Nachrichten, ältere Dateistände). Nur Umschreiben entfernt ihn: alle Commit-Prüfsummen ändern sich.
4. **Alte APKs und Release-Notizen** enthalten den Namen (Update-Adresse in der App). Entscheidung offen: ältere APK-Releases löschen,
   wenn die neue Version bei allen Testern ist. Die Releases `pakete` und `audio-en-v*` bleiben (ältere Apps laden dort ihre Pakete).

## Ablauf am Mittwoch

1. **Einfrieren:** Alle (Claude, AG, Codex) committen und pushen, danach keine Arbeit mehr bis zur Entwarnung.
2. **Sicherung:** `git clone --mirror https://github.com/angemann-app/velvet_app C:\TOOLS\backup\velvet_app-vor-umbenennung.git`.
3. **Umbenennen (Nutzer, im Browser):** GitHub → Settings → Account → *Change username* → `lotus-atelier`.
4. **Werkzeuge prüfen:** `gh auth status`; in jedem Klon `git remote set-url origin https://github.com/lotus-atelier/velvet_app.git`.
5. **Verlauf umschreiben** (Claude, frischer Spiegelklon): `git filter-repo` (per `pip install git-filter-repo`) mit Mailmap
   (`Angemann` und `angemann-app` → `lotus-atelier <346896525+lotus-atelier@users.noreply.github.com>`), `--replace-text` für Dateiinhalte
   (`angemann-app` → `lotus-atelier`), `--replace-message` für Commit-Nachrichten. Danach Force-Push aller Branches und Tags.
   Die GitHub-Releases bleiben, ihre Tags zeigen auf die umgeschriebenen Commits.
6. **Code:** Branch `umbenennung-lotus-atelier` (ersetzt den Namen an den 14 Stellen, aktualisiert die Tests) auf den neuen Verlauf setzen,
   Tests laufen lassen, mergen, **neue Beta** bauen (Build höher als der letzte) und veröffentlichen. „Was ist neu“ und `tools/release.ps1` wie gewohnt.
7. **Neu klonen:** Haupt-Checkout, alle Worktrees, der Klon von AG und der von Codex werden verworfen und neu geklont; danach
   `git config user.name lotus-atelier` und `git config user.email 346896525+lotus-atelier@users.noreply.github.com`.
8. **Kontrolle:** `git grep -i angemann` und `git log --all --format='%an %ae %cn %ce %s' | findstr /i angemann` müssen leer sein; GitHub-Seiten
   (Releases, Issues, Actions) ansehen; `gh release list` und ein Probe-Update auf dem Handy.

## Hinweis an alle, die am Projekt arbeiten (Claude, AG, Codex)

> Das GitHub-Konto `angemann-app` wird am **Mittwoch, 04.11.2026,** in `lotus-atelier` umbenannt, und der Verlauf wird umgeschrieben (alle Commit-Prüfsummen
> ändern sich). Bis dahin den Kontonamen nicht neu festschreiben, nur die vorhandenen Konstanten benutzen (`UpdateService.repo`, `tools/pakete_hochladen.ps1`).
> **Vor Beginn alles committen und pushen und dann nicht weiterarbeiten**, bis die Entwarnung kommt. Danach den eigenen Klon **verwerfen und neu klonen**
> (kein Pull, kein Rebase auf den alten Stand, kein Push aus einem alten Klon: das würde den alten Verlauf zurückbringen). Git-Name und -E-Mail auf
> `lotus-atelier` stellen. Nichts anlegen, was den alten Namen enthält.