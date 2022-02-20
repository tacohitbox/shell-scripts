#!/bin/sh

echo "Downloading Discord update..."
curl $(curl -L --head https://discord.com/api/download\?platform\=linux\&format\=tar.gz 2>/dev/null | grep location: | tail -n1 | cut -d' ' -f2 | tr -d '\r') --output discord.tar.gz
tar -xzf ./discord.tar.gz
rm ./discord.tar.gz
sudo cp -rf ./Discord/* /opt/discord
rm -rf Discord
echo "Injecting OpenAsar..."
curl $(curl -L --head https://github.com/GooseMod/OpenAsar/releases/download/nightly/app.asar 2>/dev/null | grep location: | tail -n1 | cut -d' ' -f2 | tr -d '\r') --output app.asar
sudo cp -rf ./app.asar /opt/discord/resources/app.asar
rm -rf ./app.asar
echo "Done"