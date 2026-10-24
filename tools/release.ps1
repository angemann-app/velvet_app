# Baut VelvetPulse und veröffentlicht ein GitHub-Release, das die App als Update findet.
#
#   Stabil: powershell -ExecutionPolicy Bypass -File tools\release.ps1 -Version 4.2.0 -Build 18 -Notes "Neu: …"
#   Beta:   powershell -ExecutionPolicy Bypass -File tools\release.ps1 -Version 4.2.0-beta.1 -Build 17 -Notes "…" -Beta
#
# Beta und Stabil sind immer kompatibel: gleicher Schlüssel, gleicher Paketname und EINE gemeinsame
# Build-Nummer, die mit jedem Release steigt, egal in welchem Kanal. Deshalb prüft das Skript,
# dass die Build-Nummer höher ist als die aller bisherigen Releases.
# Tag-Format v<Version>+<Build> und Asset-Namen erwartet lib/services/update_service.dart.
param(
    [Parameter(Mandatory)] [string] $Version,
    [Parameter(Mandatory)] [int] $Build,
    [Parameter(Mandatory)] [string] $Notes,
    [switch] $Beta
)
$ErrorActionPreference = "Stop"
$root = Split-Path $PSScriptRoot
Set-Location $root
$env:PATH = "C:\TOOLS\flutter\bin;$env:PATH"
$env:JAVA_HOME = "C:\TOOLS\jdk17"
$gh = "C:\TOOLS\gh\bin\gh.exe"

if (-not (Test-Path android\key.properties)) {
    throw "android\key.properties fehlt – ohne Release-Schlüssel wird nichts veröffentlicht (tools\schluessel_erstellen.ps1)."
}
if (git status --porcelain) { throw "Es gibt nicht committete Änderungen. Bitte erst committen." }
if ($Beta -and $Version -notmatch '-beta\.\d+$') { throw "Beta-Versionen heißen z. B. 4.2.0-beta.1." }
if (-not $Beta -and $Version -match '-') { throw "Stabile Versionen haben keinen Zusatz wie -beta. Für eine Beta -Beta angeben." }

$builds = & $gh release list --limit 200 --json tagName --jq '.[].tagName' |
    ForEach-Object { if ($_ -match '\+(\d+)$') { [int]$Matches[1] } }
$highest = ($builds | Measure-Object -Maximum).Maximum
if ($highest -and $Build -le $highest) {
    throw "Build $Build ist nicht höher als das bisher höchste Release (Build $highest)."
}

# Gate: ohne Eintrag im „Was ist neu“-Bildschirm kein Release.
$news = Get-Content -Raw -Encoding utf8 assets\data\neuigkeiten.json | ConvertFrom-Json
if (-not ($news.eintraege | Where-Object { $_.build -eq $Build })) {
    throw "assets\data\neuigkeiten.json hat keinen Eintrag für Build $Build (plus Englisch in translations\en\neuigkeiten.json)."
}

# Gate: ohne grüne Tests (u. a. test/security_test.dart) kein Release.
flutter test
if ($LASTEXITCODE -ne 0) { throw "Tests fehlgeschlagen – kein Release." }

flutter build apk --release --split-per-abi --build-name $Version --build-number $Build
if ($LASTEXITCODE -ne 0) { throw "Build fehlgeschlagen." }

$out = "build\release"
Remove-Item -Recurse -Force $out -ErrorAction SilentlyContinue
New-Item -ItemType Directory $out | Out-Null
$files = @()
foreach ($abi in "arm64-v8a", "armeabi-v7a", "x86_64") {
    $apk = "$out\velvetpulse-$abi.apk"
    Copy-Item "build\app\outputs\flutter-apk\app-$abi-release.apk" $apk
    (Get-FileHash $apk -Algorithm SHA256).Hash.ToLower() | Set-Content -Encoding ascii "$apk.sha256"
    $files += $apk, "$apk.sha256"
}

$tag = "v$Version+$Build"
if ($Beta) {
    & $gh release create $tag @files --title "VelvetPulse $Version" --notes $Notes --target main --prerelease
} else {
    & $gh release create $tag @files --title "VelvetPulse $Version" --notes $Notes --target main --latest
}
if ($LASTEXITCODE -ne 0) { throw "Release konnte nicht angelegt werden." }
Write-Host "Veröffentlicht: $tag$(if ($Beta) { ' (Beta)' })"
