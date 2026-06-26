# Script para copiar y renombrar fotos desde Documentacion a public/images
# Ejecutar desde la carpeta WEB: powershell -ExecutionPolicy Bypass -File scripts/copy-photos.ps1

$src = "C:\Users\Javier\Documents\Proyectos\FranciscoVela\Documentacion"
$dst = "C:\Users\Javier\Documents\Proyectos\FranciscoVela\WEB\public\images"

# Crear carpetas destino
$carpetas = @("cadiz-cf", "llerenense", "san-fernando", "formacion", "hero", "bio", "escudos", "testimonios", "logos", "entrevistas")
foreach ($c in $carpetas) {
    New-Item -ItemType Directory -Force -Path "$dst\$c" | Out-Null
}

# CADIZ CF
Write-Host "Copiando fotos Cádiz CF..."
$cadiFiles = Get-ChildItem "$src\FOTOS FRAN\CADIZ CF" -Filter "*.jpeg" | Sort-Object Name
$i = 1
foreach ($f in $cadiFiles) {
    $dest = "$dst\cadiz-cf\cadiz-{0:D3}.jpg" -f $i
    Copy-Item $f.FullName $dest -Force
    $i++
}
Write-Host "  -> $($cadiFiles.Count) fotos copiadas"

# LLERENENSE
Write-Host "Copiando fotos Llerenense..."
$llerenFiles = Get-ChildItem "$src\FOTOS FRAN\LLERENENSE" -Include "*.jpeg","*.jpg" -Recurse | Sort-Object Name
$i = 1
foreach ($f in $llerenFiles) {
    $dest = "$dst\llerenense\llerenense-{0:D3}.jpg" -f $i
    Copy-Item $f.FullName $dest -Force
    $i++
}
Write-Host "  -> $($llerenFiles.Count) fotos copiadas"

# SAN FERNANDO
Write-Host "Copiando fotos San Fernando..."
$sfDir = "$src\FOTOS FRAN\SAN FERNANDO CD"
if (Test-Path $sfDir) {
    $sfFiles = Get-ChildItem $sfDir -Include "*.jpeg","*.jpg" -Recurse | Sort-Object Name
    $i = 1
    foreach ($f in $sfFiles) {
        $dest = "$dst\san-fernando\san-fernando-{0:D3}.jpg" -f $i
        Copy-Item $f.FullName $dest -Force
        $i++
    }
    Write-Host "  -> $($sfFiles.Count) fotos copiadas"
} else {
    Write-Host "  -> Carpeta SAN FERNANDO CD no encontrada"
}

# FORMACION
Write-Host "Copiando fotos Formación..."
$formFiles = Get-ChildItem "$src\FORMACION" -Include "*.jpeg","*.jpg","*.png" -Recurse | Sort-Object Name
$i = 1
foreach ($f in $formFiles) {
    $ext = $f.Extension.ToLower() -replace "jpeg","jpg"
    $dest = "$dst\formacion\formacion-{0:D3}.jpg" -f $i
    Copy-Item $f.FullName $dest -Force
    $i++
}
Write-Host "  -> $($formFiles.Count) fotos copiadas"

# HERO - Unknown-66.jpeg de Cádiz CF como imagen principal
Write-Host "Configurando fotos hero..."
$heroSrc = "$src\FOTOS FRAN\CADIZ CF\Unknown-66.jpeg"
if (Test-Path $heroSrc) {
    Copy-Item $heroSrc "$dst\hero\hero-main.jpg" -Force
    Write-Host "  -> hero-main.jpg configurado (Unknown-66)"
} elseif (Test-Path "$dst\cadiz-cf\cadiz-001.jpg") {
    Copy-Item "$dst\cadiz-cf\cadiz-001.jpg" "$dst\hero\hero-main.jpg" -Force
    Write-Host "  -> hero-main.jpg configurado (cadiz-001, fallback)"
}
if (Test-Path "$dst\cadiz-cf\cadiz-005.jpg") {
    Copy-Item "$dst\cadiz-cf\cadiz-005.jpg" "$dst\hero\hero-cta.jpg" -Force
    Write-Host "  -> hero-cta.jpg configurado"
}

# BIO
if (Test-Path "$dst\cadiz-cf\cadiz-003.jpg") {
    Copy-Item "$dst\cadiz-cf\cadiz-003.jpg" "$dst\bio\francisco-vela-bio.jpg" -Force
    Write-Host "  -> Foto bio configurada"
}

Write-Host ""
Write-Host "✓ Proceso completado."
Write-Host ""
Write-Host "PENDIENTE - Añadir manualmente:"
Write-Host "  - public/images/escudos/cadiz-cf.png"
Write-Host "  - public/images/escudos/llerenense.png"
Write-Host "  - public/images/escudos/san-fernando.png"
Write-Host "  - public/images/escudos/chiclana-cf.png"
Write-Host "  - public/images/logos/ (instituciones formación)"
Write-Host "  - public/audio/entrevista-cope-llerena-1.mp3"
Write-Host "  - public/audio/entrevista-cope-llerena-2.mp3"
Write-Host "  - public/cv-francisco-vela-es.pdf"
Write-Host "  - public/cv-francisco-vela-en.pdf"
Write-Host "  - public/fonts/ (BebasNeue-Regular.woff2, Inter-*.woff2)"
