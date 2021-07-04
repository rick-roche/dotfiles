#!/bin/bash

dir=$(dirname "$0")
ms_script_url='https://dotnet.microsoft.com/download/dotnet-core/scripts/v1/dotnet-install.sh'
ms_script_name='dotnet-install.sh'

curl -L --fail -o "$dir"/"$ms_script_name" "$ms_script_url"
chmod +x "$dir"/"$ms_script_name"

# Install dotnet lts
bash "$dir"/"$ms_script_name" --channel LTS

# Install dotnet 5
bash "$dir"/"$ms_script_name" --channel Current

# Install dotnet 6 preview
bash "$dir"/"$ms_script_name" --channel 6.0

# Install global tools
dotnet tool install --global dotnet-outdated-tool
