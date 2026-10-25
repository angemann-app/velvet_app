# Lädt das englische Audiopaket (build/velvetpulse-audio-en.zip + .sha256) als eigenes GitHub-Release hoch.
# Tag ohne „+Build“ (z. B. audio-en-v1): Die Update-Suche der App wählt es nie als App-Update.
# Die App lädt das Paket von genau dieser Adresse (lib/services/sprachausgabe.dart, AudioPaket.paketUrl).
#
# Ältere Pakete (audio-en-v1 …) nie löschen: ältere App-Versionen laden fest von ihrer Adresse.
#
#   powershell -ExecutionPolicy Bypass -File tools\audiopaket_hochladen.ps1
param([string] $Tag = "audio-en-v3")
$ErrorActionPreference = "Stop"
$root = Split-Path $PSScriptRoot
Set-Location $root
$gh = "C:\TOOLS\gh\bin\gh.exe"
$zip = "build\velvetpulse-audio-en.zip"
if (-not (Test-Path $zip) -or -not (Test-Path "$zip.sha256")) { throw "Paket fehlt – erst tools\generate_audio_en.py ausführen." }

$soll = (Get-Content "$zip.sha256").Split(" ")[0]
$ist = (Get-FileHash $zip -Algorithm SHA256).Hash.ToLower()
if ($soll -ne $ist) { throw "Prüfsumme der Datei passt nicht zur .sha256." }

$mb = [math]::Round((Get-Item $zip).Length / 1MB, 1)
$notes = "Englische Aufnahmen für VelvetPulse ($mb MB): Lektionen, Gemeinsamer Abend, Selbsterkundung, Beckenboden-Ansagen. " +
         "Wird in der App unter Profil › Sprache nachgeladen und dort per SHA-256 geprüft. Kein App-Update.`n`n" +
         "English recordings for VelvetPulse ($mb MB), downloaded inside the app (Profile › Language). Not an app update."
& $gh release create $Tag $zip "$zip.sha256" --title "Englisches Audiopaket ($Tag)" --notes $notes --latest=false
if ($LASTEXITCODE -ne 0) { throw "Release konnte nicht angelegt werden." }
Write-Host "Hochgeladen: $Tag ($mb MB)"
