# Baut VelvetPulse und veröffentlicht ein GitHub-Release, das die App als Update findet.
#
#   powershell -ExecutionPolicy Bypass -File tools\release.ps1 -Version 4.1.0 -Build 13 -Notes "Neu: …"
#
# Die Build-Nummer muss höher sein als die aller bisherigen Releases.
# Tag-Format v<Version>+<Build> und Asset-Namen erwartet lib/services/update_service.dart.
param(
    [Parameter(Mandatory)] [string] $Version,
    [Parameter(Mandatory)] [int] $Build,
    [Parameter(Mandatory)] [string] $Notes
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
& $gh release create $tag @files --title "VelvetPulse $Version" --notes $Notes --target main
if ($LASTEXITCODE -ne 0) { throw "Release konnte nicht angelegt werden." }
Write-Host "Veröffentlicht: $tag"
