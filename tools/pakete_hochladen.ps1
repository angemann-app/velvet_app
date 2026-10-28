# Baut die Audio-Pakete, signiert das Verzeichnis und veröffentlicht beides:
# 1. tools/pakete_bauen.py  2. tools/pakete_verzeichnis.dart  3. GitHub-Release „pakete“ (zweite Adresse)
# 4. Workflow „Pakete nach R2“ kopiert alles nach Cloudflare R2 (erste Adresse).
# Ältere Pakete bleiben im Release liegen (ältere App-Versionen und das alte Verzeichnis zeigen auf sie).
#
#   powershell -ExecutionPolicy Bypass -File tools\pakete_hochladen.ps1 [-EnQuelle C:\TOOLS\workspace\mojo\build\audio_en]
param([string] $EnQuelle = "")
# Nicht "Stop": PowerShell 5.1 behandelt jede Ausgabe nativer Programme auf stderr (z. B. gh „release not
# found“) sonst als Abbruch. Fehler werden unten über $LASTEXITCODE geprüft.
$ErrorActionPreference = "Continue"
$root = Split-Path $PSScriptRoot
Set-Location $root
$gh = "C:\TOOLS\gh\bin\gh.exe"
$py = "C:\TOOLS\kikiri-venv\Scripts\python.exe"
$repo = "angemann-app/velvet_app"

if ($EnQuelle) { & $py -X utf8 tools\pakete_bauen.py --en-quelle $EnQuelle } else { & $py -X utf8 tools\pakete_bauen.py }
if ($LASTEXITCODE -ne 0) { throw "Pakete bauen fehlgeschlagen." }
& C:\TOOLS\flutter\bin\dart.bat run tools/pakete_verzeichnis.dart
if ($LASTEXITCODE -ne 0) { throw "Verzeichnis signieren fehlgeschlagen." }

& $gh release view pakete --repo $repo *> $null
if ($LASTEXITCODE -ne 0) {
    & $gh release create pakete --repo $repo --title "Audio-Pakete" --latest=false `
        --notes "Aufnahmen für VelvetPulse, werden in der App nachgeladen (signiertes Verzeichnis audio-index.json). Kein App-Update."
    if ($LASTEXITCODE -ne 0) { throw "Release pakete konnte nicht angelegt werden." }
}
# Pakete nur für R2 (Lust im Traum, Innenansichten) gehen nur verschlüsselt ins Release; der Workflow entschlüsselt und löscht sie.
$nurR2 = @(Get-ChildItem build\pakete\*-lust-v*.zip, build\pakete\*-reihe-v*.zip -ErrorAction SilentlyContinue)
foreach ($z in $nurR2) {
    & C:\TOOLS\flutter\bin\dart.bat run tools/paket_transport.dart verschluesseln $z.FullName "$($z.FullName).enc"
    if ($LASTEXITCODE -ne 0) { throw "Verschlüsseln von $($z.Name) fehlgeschlagen." }
}
$dateien = @(Get-ChildItem build\pakete\*.zip | Where-Object { $_.Name -notlike "*-lust-v*" -and $_.Name -notlike "*-reihe-v*" } | ForEach-Object FullName) +
    @(Get-ChildItem build\pakete\*.zip.enc -ErrorAction SilentlyContinue | ForEach-Object FullName) +
    @("build\pakete\audio-index.json.sig", "build\pakete\audio-index.json")
& $gh release upload pakete @dateien --repo $repo --clobber
if ($LASTEXITCODE -ne 0) { throw "Hochladen nach GitHub fehlgeschlagen." }

& $gh workflow run pakete-nach-r2.yml --repo $repo
if ($LASTEXITCODE -ne 0) { throw "Workflow Pakete nach R2 konnte nicht gestartet werden." }
Write-Host "Hochgeladen nach GitHub; Kopie nach R2 läuft (GitHub → Actions → Pakete nach R2)."
