#!/bin/sh
echo "This script updates Discord, injects OpenAsar, and injects GooseMod."

# Check if running with root
if (( $EUID == 0 )); then
    echo "Please do not run with root or sudo!"
    exit
fi

# Discord Update
echo "Downloading Discord update..."
curl $(curl -L --head https://discord.com/api/download\?platform\=linux\&format\=tar.gz 2>/dev/null | grep location: | tail -n1 | cut -d' ' -f2 | tr -d '\r') --output discord.tar.gz
tar -xzf ./discord.tar.gz
rm ./discord.tar.gz
sudo cp -rf ./Discord/* /opt/discord
rm -rf Discord
echo "Finished updating Discord."

# OpenAsar
echo "Injecting OpenAsar..."
curl $(curl -L --head https://github.com/GooseMod/OpenAsar/releases/download/nightly/app.asar 2>/dev/null | grep location: | tail -n1 | cut -d' ' -f2 | tr -d '\r') --output app.asar
sudo cp -rf ./app.asar /opt/discord/resources/app.asar
rm -rf ./app.asar
echo "Finished injecting OpenAsar."

# Install jq if necessary. for JSON parsing in shell.
if ! [ -x "$(command -v jq)" ]; then
  echo 'jq is not installed, which is needed for injecting GooseMod.'
  echo 'Installing jq...'
  sudo wget https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 -O /usr/bin/jq
  sudo chmod +x /usr/bin/jq
fi

# GooseMod
echo "Injecting GooseMod"
cat $HOME/.config/discord/settings.json | jq --arg endpoint https://updates.goosemod.com/goosemod '. + {UPDATE_ENDPOINT: $endpoint, NEW_UPDATE_ENDPOINT: $endpoint}' | tee $HOME/.config/discord/settings.json
echo "Finished injecting GooseMod."

echo "Done."
