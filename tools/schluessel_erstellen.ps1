# Erzeugt den Release-Signierschlüssel für VelvetPulse und android/key.properties.
# Einmalig ausführen. Schlüssel und Passwort SICHER AUFBEWAHREN (z. B. Passwort-Manager + Kopie
# der .jks-Datei auf einem USB-Stick): Ohne sie lassen sich keine Updates mehr installieren.
$ErrorActionPreference = "Stop"
$keystore = "C:\TOOLS\velvetpulse-schluessel\velvetpulse-release.jks"
$keytool = "C:\TOOLS\jdk17\bin\keytool.exe"
$properties = Join-Path $PSScriptRoot "..\android\key.properties"

if (Test-Path $keystore) { Write-Host "Es gibt schon einen Schlüssel: $keystore"; exit 1 }
New-Item -ItemType Directory -Force (Split-Path $keystore) | Out-Null

do {
    $p1 = Read-Host "Neues Passwort für den Schlüssel (mind. 8 Zeichen)" -AsSecureString
    $p2 = Read-Host "Passwort wiederholen" -AsSecureString
    $plain1 = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($p1))
    $plain2 = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($p2))
    if ($plain1 -ne $plain2) { Write-Host "Die Passwörter stimmen nicht überein." }
    elseif ($plain1.Length -lt 8) { Write-Host "Bitte mindestens 8 Zeichen." }
} until ($plain1 -eq $plain2 -and $plain1.Length -ge 8)

$env:VP_KEY_PASS = $plain1
& $keytool -genkeypair -keystore $keystore -storetype PKCS12 -keyalg RSA -keysize 2048 -validity 10000 `
    -alias velvetpulse -dname "CN=VelvetPulse" -storepass:env VP_KEY_PASS -keypass:env VP_KEY_PASS
Remove-Item Env:VP_KEY_PASS

@"
storeFile=$($keystore -replace '\\', '/')
storePassword=$plain1
keyAlias=velvetpulse
keyPassword=$plain1
"@ | Set-Content -Encoding ascii $properties

Write-Host ""
Write-Host "Fertig. Schlüssel: $keystore"
Write-Host "Bitte jetzt sichern: die .jks-Datei UND das Passwort."
