#!/bin/bash
cd "$(dirname "$0")"
unzip input.jar -d decomp
find ./decomp -name "*.class" -exec rm {} \;
java -jar cfr-0.152.jar input.jar --outputdir ./decomp
python3 mapper.py
