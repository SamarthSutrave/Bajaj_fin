$projectDir = "c:\Users\Dell\Downloads\bfh-java-assignment\bfh-java-assignment"
$targetDir = "$projectDir\target\classes"
$m2Repo = "$env:USERPROFILE\.m2\repository"
$jarDir = "$projectDir\target"
$fatJarFile = "$jarDir\bfh-java-assignment-1.0.0-fat.jar"
$tempDir = "$jarDir\fat-jar-temp"

Write-Host "Building fat JAR..."

if (!(Test-Path "$targetDir\com")) {
    Write-Host "ERROR: Compiled classes not found!"
    exit 1
}

if (Test-Path $tempDir) {
    Remove-Item -Path $tempDir -Recurse -Force
}
New-Item -ItemType Directory -Path $tempDir -Force | Out-Null

Write-Host "Copying compiled classes..."
Copy-Item -Path "$targetDir\*" -Destination "$tempDir\" -Recurse -Force

$libDir = "$tempDir\lib"
New-Item -ItemType Directory -Path $libDir -Force | Out-Null

Write-Host "Copying dependencies..."
$jarCount = 0
Get-ChildItem -Path $m2Repo -Recurse -Filter "*.jar" -ErrorAction SilentlyContinue | ForEach-Object {
    $name = $_.Name
    if (($name -match "spring-boot|spring-|logback|slf4j|jackson|lombok|netty|reactor|commons|snakeyaml") -and 
        -not ($name -match "maven-|slf4j-api-1\.7")) {
        Copy-Item -Path $_.FullName -Destination $libDir -Force -ErrorAction SilentlyContinue
        $jarCount++
    }
}

Write-Host "Copied $jarCount dependencies"

$metaInf = "$tempDir\META-INF"
New-Item -ItemType Directory -Path $metaInf -Force | Out-Null

$manifest = "Manifest-Version: 1.0`nMain-Class: com.bfh.AssignmentApplication`n`n"
Set-Content -Path "$metaInf\MANIFEST.MF" -Value $manifest -Encoding ASCII -NoNewline

Write-Host "Creating fat JAR..."
Push-Location $tempDir
jar cfm "$fatJarFile" "$metaInf\MANIFEST.MF" .
Pop-Location

if (Test-Path $fatJarFile) {
    $size = [Math]::Round((Get-Item $fatJarFile).Length / 1MB, 2)
    Write-Host "SUCCESS: Fat JAR created!" -ForegroundColor Green
    Write-Host "File: $fatJarFile"
    Write-Host "Size: $size MB"
    Remove-Item -Path $tempDir -Recurse -Force
} else {
    Write-Host "FAILED: Could not create fat JAR"
    exit 1
}
