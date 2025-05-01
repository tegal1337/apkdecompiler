@echo off
echo Creating executable from JAR...

REM Get project root directory (parent of build directory)
set BUILD_DIR=%~dp0
for %%a in ("%BUILD_DIR:~0,-1%") do set PROJECT_ROOT=%%~dpa

REM Navigate to project root
cd "%PROJECT_ROOT%"

REM Check if JAR exists
if not exist target\apkdecompiler-1.0-SNAPSHOT-jar-with-dependencies.jar (
    echo JAR file not found. Building project...
    call mvn clean package
    if errorlevel 1 (
        echo Build failed. Please check the errors above.
        exit /b 1
    )
)

REM Path to Launch4j - update this to your Launch4j installation path
set LAUNCH4J_PATH=C:\Program Files (x86)\Launch4j

REM Configuration file for Launch4j
echo ^<?xml version="1.0" encoding="UTF-8"?^> > config.xml
echo ^<launch4jConfig^> >> config.xml
echo   ^<dontWrapJar^>false^</dontWrapJar^> >> config.xml
echo   ^<headerType^>console^</headerType^> >> config.xml
echo   ^<jar^>target\apkdecompiler-1.0-SNAPSHOT-jar-with-dependencies.jar^</jar^> >> config.xml
echo   ^<outfile^>ApkDecompiler.exe^</outfile^> >> config.xml
echo   ^<errTitle^>APK Decompiler^</errTitle^> >> config.xml
echo   ^<cmdLine^>^</cmdLine^> >> config.xml
echo   ^<chdir^>^</chdir^> >> config.xml
echo   ^<priority^>normal^</priority^> >> config.xml
echo   ^<downloadUrl^>http://java.com/download^</downloadUrl^> >> config.xml
echo   ^<supportUrl^>^</supportUrl^> >> config.xml
echo   ^<stayAlive^>false^</stayAlive^> >> config.xml
echo   ^<restartOnCrash^>false^</restartOnCrash^> >> config.xml
echo   ^<manifest^>^</manifest^> >> config.xml
echo   ^<icon^>^</icon^> >> config.xml
echo   ^<jre^> >> config.xml
echo     ^<path^>^</path^> >> config.xml
echo     ^<bundledJre64Bit^>false^</bundledJre64Bit^> >> config.xml
echo     ^<bundledJreAsFallback^>false^</bundledJreAsFallback^> >> config.xml
echo     ^<minVersion^>11.0.0^</minVersion^> >> config.xml
echo     ^<maxVersion^>^</maxVersion^> >> config.xml
echo     ^<jdkPreference^>preferJre^</jdkPreference^> >> config.xml
echo     ^<runtimeBits^>64/32^</runtimeBits^> >> config.xml
echo   ^</jre^> >> config.xml
echo ^</launch4jConfig^> >> config.xml

REM Run Launch4j to create the EXE
"%LAUNCH4J_PATH%\launch4jc.exe" config.xml

IF %ERRORLEVEL% EQU 0 (
    echo EXE creation successful! File: ApkDecompiler.exe
) ELSE (
    echo Error creating EXE. Please check the paths and try again.
)

REM Clean up the config file
del config.xml

echo Done.