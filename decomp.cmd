@echo off
cd /d "%~dp0"
rmdir /s /q .\decomp\*
powershell Expand-Archive -Path input.jar -DestinationPath .\decomp\
for /r .\decomp\ %%i in (*.class) do del "%%i"
java -jar cfr-0.152.jar input.jar --outputdir .\decomp\
python mapper.py
