#!/bin/bash
[ ! -f ./checked_links ] && touch checked_links
curl -A "Mozila/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101 Firefox/81.0" -s https://old.reddit.com/r/linux_gaming/comments/t57lgq/apex_legends_on_linux_support_megathread/ | grep -Eo "(http|https)://[a-zA-Z0
-9./?=_%:-]*" | grep "cdn.dis" | grep "r5apex.dxvk-cache" > temp.links
current_shader=$(wc -c ~/.steam/steam/steamapps/shadercache/1172470/DXVK_state_cache/r5apex.dxvk-cache | cut -d' ' -f 1)
links_to_check=$(diff checked_links temp.links | grep ">" | sed 's/> //g')
shaders_location="$HOME/.steam/steam/steamapps/shadercache/1172470/DXVK_state_cache/"
echo $links_to_check | sed 's/ /\n/g' | uniq > links_to_check

changed=0
while read -r line; do
        echo "$line" >> checked_links
        wget -q -O r5apex.dxvk-cache $line > /dev/null 2>&1
        if [ "$current_shader" -lt "$(wc -c r5apex.dxvk-cache | cut -d' ' -f 1)" ]
        then
                if [ "$(ps -e | grep -c steam)" -ne 0 ]
                then
                        pkill steam
                        sleep 3 #my pc is kind slow
                fi

                mv "$shaders_location"r5apex.dxvk-cache "$shaders_location"r5apex.dxvk-cache.old"$(ls -l $shaders_location | wc -l)"
                mv "r5apex.dxvk-cache" "$shaders_location"
                current_shader=$(wc -c "$HOME"/.steam/steam/steamapps/shadercache/1172470/DXVK_state_cache/r5apex.dxvk-cache | cut -d' ' -f 1)
                changed=1
        fi
done < links_to_check

case $changed in
        1)
                echo "Found better cache"
                ;;
        0)
                echo "You have da best"
                ;;
esac

rm temp.links links_to_check
[ -f r5apex.dxvk-cache ] && rm r5apex.dxvk-cache
