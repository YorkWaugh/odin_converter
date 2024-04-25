@echo off

setlocal EnableDelayedExpansion

cd /d "input"

if "%PROCESSOR_ARCHITECTURE%"=="AMD64" (
  set "ARCH=x64"
) else (
  set "ARCH=x86"
)

set log="%~dp0\log.txt"

for %%a in (*.zip) do (
  echo stage1 unpack "%%a"
  "%~dp0\utils\%ARCH%\7z.exe" x "%%a" -o"..\tmp\stage1" -y >> %log%
)

cd /d "..\tmp\stage1"

for %%a in (*.tar.md5) do (
  echo stage2 unpack "%%a"
  "%~dp0\utils\%ARCH%\7z.exe" x "%%a" -o"..\stage2" -y >> %log%
)

cd /d "..\stage2"

for %%a in (*.lz4) do (
  echo stage3 unpack "%%a"
  "%~dp0\utils\%ARCH%\7z.exe" x "%%a" -o"..\stage3" -y >> %log%
)

for %%a in (*.pit) do (
  echo stage3 copy "%%a"
  copy "%%a" "..\stage3" >> %log%
)

cd /d "..\stage3"

echo stage4 pack output.tar
"%~dp0\utils\%ARCH%\7z.exe" a -tTar "..\..\output\output.tar" * >> %log%

echo clean temp files

cd /d "..\.."

rd /s /q "tmp"

pause