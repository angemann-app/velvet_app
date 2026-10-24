# Testet lokale KI-Modelle direkt auf dem angeschlossenen Android-Handy (nur Messung, nichts an der App).
# Kopiert llama.cpp (allgemeine Android-ARM64-Version, läuft auf MediaTek wie Snapdragon) und ein Modell
# nach /data/local/tmp/vp_ki, misst das Tempo und stellt eine Coach-Frage. Danach wird alles gelöscht.
#
#   powershell -ExecutionPolicy Bypass -File tools\handy_ki_test.ps1 -Modell gemma-4-E2B-it-Q4_K_M.gguf
param(
    [string] $Modell = "gemma-4-E2B-it-Q4_K_M.gguf",
    [switch] $Behalten
)
$ErrorActionPreference = "Stop"
$adb = "C:\TOOLS\android-sdk\platform-tools\adb.exe"
$bin = "C:\TOOLS\llama.cpp\android\llama-b11800"
$gguf = "C:\TOOLS\llm-modelle\$Modell"
$ziel = "/data/local/tmp/vp_ki"

& $adb get-state | Out-Null
"--- Gerät"
& $adb shell "getprop ro.product.model; getprop ro.soc.manufacturer; getprop ro.soc.model; grep MemTotal /proc/meminfo; df -h /data | tail -1"

$frei = [int64](& $adb shell "df -k /data | tail -1" | ForEach-Object { ($_ -split '\s+')[3] }) * 1KB
$noetig = (Get-Item $gguf).Length + 200MB
if ($frei -lt $noetig + 2GB) { throw "Zu wenig freier Speicher auf dem Handy ($([math]::Round($frei/1GB,1)) GB frei)." }

"--- Kopieren"
& $adb shell "mkdir -p $ziel"
# Einzeln statt als Ordner: „adb push ordner\.“ blieb unter Windows hängen.
foreach ($datei in Get-ChildItem $bin -File | Where-Object { $_.Name -in 'llama-bench', 'llama-completion' -or $_.Extension -eq '.so' }) {
    & $adb push $datei.FullName "$ziel/$($datei.Name)" | Out-Null
}
& $adb push $gguf "$ziel/$Modell"
& $adb shell "chmod 755 $ziel/llama-*"

"--- Tempo (llama-bench, nur Prozessor)"
& $adb shell "cd $ziel && LD_LIBRARY_PATH=. ./llama-bench -m $Modell -p 256 -n 64 -t 6"

"--- Coach-Frage"
$frage = "Ich komme beim Sex mit meiner Freundin immer viel zu schnell. Was kann ich tun? Antworte auf Deutsch, warm und in zwei kurzen Absätzen."
& $adb shell "cd $ziel && LD_LIBRARY_PATH=. ./llama-completion -m $Modell -t 6 -n 250 --temp 0.7 -no-cnv -p '$frage'"

if (-not $Behalten) {
    "--- Aufräumen"
    & $adb shell "rm -rf $ziel"
}
