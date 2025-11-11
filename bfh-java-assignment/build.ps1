#!/usr/bin/env powershell
param(
    [string]$Action = "build"  # "build" or "run"
)

$projectDir = "c:\Users\Dell\Downloads\bfh-java-assignment\bfh-java-assignment"
$srcDir = "$projectDir\src\main\java"
$targetDir = "$projectDir\target\classes"
$resourcesDir = "$projectDir\src\main\resources"

# Build classpath from Maven cache
$m2Repo = "$env:USERPROFILE\.m2\repository"
$jars = @()
Get-ChildItem -Path $m2Repo -Recurse -Filter "*.jar" -ErrorAction SilentlyContinue | Where-Object {
    # Exclude conflicting libraries
    $name = $_.Name
    -not ($name -match "slf4j-api-1\.7" -or $name -match "maven-.*-plugin")
} | ForEach-Object {
    $jars += "`"$($_.FullName)`""
}
$classpath = ($jars -join ";") + ";`"$targetDir`""

Write-Host "Project directory: $projectDir"
Write-Host "Source directory: $srcDir"
Write-Host "Target directory: $targetDir"
Write-Host "Resources directory: $resourcesDir"
Write-Host "Found $($jars.Count) JAR files in Maven cache"
Write-Host ""

if ($Action -eq "build") {
    Write-Host "=== Compiling Java Sources ==="
    $javaFiles = Get-ChildItem -Path $srcDir -Recurse -Filter "*.java"
    Write-Host "Found $($javaFiles.Count) Java files to compile"
    
    if ($javaFiles.Count -eq 0) {
        Write-Host "ERROR: No Java source files found!"
        exit 1
    }
    
    # Create target directory if it doesn't exist
    if (!(Test-Path $targetDir)) {
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
    }
    
    # Compile all Java files
    $javaFilePaths = $javaFiles | ForEach-Object { "`"$($_.FullName)`"" }
    $compileCmd = "javac -cp `"$classpath`" -d `"$targetDir`" -source 17 -target 17 $($javaFilePaths -join ' ')"
    
    Write-Host "Executing: javac -cp <classpath> -d $targetDir ..."
    Invoke-Expression $compileCmd
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Compilation successful!" -ForegroundColor Green
        
        # Copy resources
        if (Test-Path $resourcesDir) {
            Write-Host "Copying resources..."
            Copy-Item -Path "$resourcesDir\*" -Destination $targetDir -Force -Recurse
        }
        exit 0
    } else {
        Write-Host "Compilation failed!" -ForegroundColor Red
        exit 1
    }
}
elseif ($Action -eq "run") {
    Write-Host "=== Running Application ==="
    
    if (!(Test-Path "$targetDir\com\bfh\AssignmentApplication.class")) {
        Write-Host "ERROR: Application not compiled. Run build first!" -ForegroundColor Red
        exit 1
    }
    
    Write-Host "Starting Spring Boot application..."
    Write-Host ""
    
    $runCmd = "java -cp `"$classpath`" com.bfh.AssignmentApplication"
    Write-Host "Executing: $runCmd"
    Write-Host ""
    
    Invoke-Expression $runCmd
    exit $LASTEXITCODE
}
else {
    Write-Host "Usage: .\build.ps1 [build|run]"
    exit 1
}
