#!/bin/bash

function download_tool() {
	mkdir -p dxvk_tool
	wget -P ./dxvk_tool https://lutris.nyc3.cdn.digitaloceanspaces.com/games/overwatch/merge-tool.tar.xz > /dev/null 2>&1
	tar -xf ./dxvk_tool/merge-tool.tar.xz > /dev/null 2>&1
}

[ ! -f "dxvk-cache-tool" ] && download_tool
url=$(curl -A "Mozila/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/81.0" -s https://old.reddit.com/r/linux_gaming/comments/t5xrho/dxvk_state_cache_for_fixing_stutter_in_apex/ | grep -Eo "(http|https)://[a-zA-Z0-9./?=_%:-]*" | grep "r5apex.dxvk-cache" | head -n 1)
search_shader="$(find $HOME -name r5apex.dxvk-cache)"
if [ ! -z $search_shader ]
then
    if [ "$(ps -e | grep -c steam)" -ne 0 ]
    then
        pkill steam
        sleep 3
    fi
    wget -q -O output.dxvk-cache $url > /dev/null 2>&1
    sleep .5
    ./dxvk-cache-tool "$search_shader" "output.dxvk-cache"
    rm "$search_shader"
    mv output.dxvk-cache "$search_shader"
else
    echo "Script coud not locate r5apex.dxvk-cache"
fi


