#!/bin/bash

function download_tool() {
	mkdir -p dxvk_tool
	wget -P ./dxvk_tool https://lutris.nyc3.cdn.digitaloceanspaces.com/games/overwatch/merge-tool.tar.xz > /dev/null 2>&1
	tar -xf ./dxvk_tool/merge-tool.tar.xz > /dev/null 2>&1
}

[ ! -f "dxvk-cache-tool" ] && download_tool
url=$(curl -A "Mozila/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/81.0" -s https://old.reddit.com/r/linux_gaming/comments/t5xrho/dxvk_state_cache_for_fixing_stutter_in_apex/ | grep -Eo "(http|https)://[a-zA-Z0-9./?=_%:-]*" | grep "r5apex.dxvk-cache" | head -n 1)
current_shader="$HOME/.steam/steam/steamapps/shadercache/1172470/DXVK_state_cache/r5apex.dxvk-cache"

if [ "$(ps -e | grep -c steam)" -ne 0 ]
then
	pkill steam
	sleep 3 #my pc is kind slow
fi

wget -q -O output.dxvk-cache $url > /dev/null 2>&1
sleep .5
if [  -f "$current_shader" ]
then
	./dxvk-cache-tool "$current_shader" "output.dxvk-cache"
	rm "$current_shader"
fi
mv output.dxvk-cache "$current_shader"
