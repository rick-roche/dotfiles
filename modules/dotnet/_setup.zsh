#!/bin/zsh

DIR=$(dirname "$0")
ms_script_url='https://dotnet.microsoft.com/download/dotnet-core/scripts/v1/dotnet-install.sh'
ms_script_name='dotnet-install.sh'

curl -L --fail -o "$DIR"/"$ms_script_name" "$ms_script_url"
chmod +x "$DIR"/"$ms_script_name"

channels=('LTS' 'Current' '6.0')

for ch in "${channels[@]}"; do
    bash "$DIR"/"$ms_script_name" --channel "$ch"
done

tools=('dotnet-outdated-tool' 'security-scan')

for t in "${tools[@]}"; do
    "$HOME"/.dotnet/dotnet tool update --global "$t"
done
