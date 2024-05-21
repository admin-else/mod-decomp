#!/bin/bash
if [ -d decomp ]; then
    echo "there is already a decomp folder press enter to delte it and write the new decomp into it or press CTRL+C to abort..."
    read
    rm -rf decomp
fi

if [ ! -f input.jar ]; then
    echo "No input.jar found... please provide an input and check that you are in the correct directory..."
    exit 1
fi

if [ ! -f .cfr.jar ]; then
    wget "https://github.com/leibnitz27/cfr/releases/download/0.152/cfr-0.152.jar" -O .cfr.jar
fi

read -p "Enter the version the mod you are tring to decompile was made for: " MCVID

MCVURL=`curl -s "https://piston-meta.mojang.com/mc/game/version_manifest_v2.json" | jq -r --arg MCVID "$MCVID" '.versions[]  | select(.id == $MCVID) | .url'`
if [ -z "${MCVURL}" ]; then
  echo this version does not exist
  exit 1
fi

MCVDATA=$(curl -s "$MCVURL")
has_mappings=$(echo "$MCVDATA" | jq -r '.downloads.client_mappings')
if [ "$has_mappings" == "null" ]; then
    echo there are no mappings avalible for this version...
    exit 1
fi

wget $(echo "$MCVDATA" | jq -r '.downloads.client_mappings.url') -O mappings.txt
unzip input.jar -d decomp
find ./decomp -name "*.class" -exec rm {} \;
java -jar .cfr.jar input.jar --outputdir decomp --obfuscationpath mappings.txt
rm mappings.txt