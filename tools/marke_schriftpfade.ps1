# Konvertiert die OFL-Wortmarke in echte Vektorpfade. Keine Fontdatei für SVG nötig.
Add-Type -AssemblyName System.Drawing
$projekt = Split-Path $PSScriptRoot -Parent
$schrift = New-Object System.Drawing.Text.PrivateFontCollection
$schrift.AddFontFile((Join-Path $projekt 'assets/fonts/SourceSerif4-Regular.ttf'))
$pfad = New-Object System.Drawing.Drawing2D.GraphicsPath
$pfad.AddString('VelvetPulse', $schrift.Families[0], 0, 112, [System.Drawing.PointF]::new(0,0), [System.Drawing.StringFormat]::GenericTypographic)
$grenzen = $pfad.GetBounds()
$punkte = $pfad.PathPoints
$typen = $pfad.PathTypes
$liste = for ($index = 0; $index -lt $punkte.Length; $index++) {
    ,@([Math]::Round($punkte[$index].X - $grenzen.X, 4), [Math]::Round($punkte[$index].Y - $grenzen.Y, 4), [int]$typen[$index])
}
$ergebnis = @{schrift=$schrift.Families[0].Name; breite=$grenzen.Width; hoehe=$grenzen.Height; punkte=@($liste)}
$ziel = Join-Path $projekt 'marketing/marke/v1/quellen/wortmarke-pfade.json'
$ergebnis | ConvertTo-Json -Depth 5 -Compress | Set-Content -LiteralPath $ziel -Encoding utf8
$pfad.Dispose()
$schrift.Dispose()
