#!/bin/bash

echo "░█▀▀█ ░█▀▀█ ─█▀▀█ ░█──░█ ░█▀▀█ ░█──░█ ▀▀█▀▀ █▀▀█" > "$(dirname "${BASH_SOURCE[0]}")/opacity_multi_apps.log"
echo "░█─▄▄ ░█▄▄▀ ░█▄▄█ ░█▄▄▄█ ░█▀▀▄ ░█▄▄▄█ ─░█── ──▀▄" >> "$(dirname "${BASH_SOURCE[0]}")/opacity_multi_apps.log"
echo "░█▄▄█ ░█─░█ ░█─░█ ──░█── ░█▄▄█ ──░█── ─░█── █▄▄█" >> "$(dirname "${BASH_SOURCE[0]}")/opacity_multi_apps.log"
echo "I code with tears and dreams, debugging life's cruel errors -Graybyt3" >> "$(dirname "${BASH_SOURCE[0]}")/opacity_multi_apps.log"

LOGFILE="$(dirname "${BASH_SOURCE[0]}")/opacity_multi_apps.log"
echo "Hey, script started at $(date)" > "$LOGFILE"

XDG_SESSION=$(echo "$XDG_SESSION_TYPE")
echo "Session type is: $XDG_SESSION" >> "$LOGFILE"
if [ "$XDG_SESSION" != "x11" ]; then
    echo "Oh no, need X11, not $XDG_SESSION!" >> "$LOGFILE"
    exit 1
fi

sleep 5

opacity="0xf3333332"
echo "Setting opacity to: $opacity, looks cool!" >> "$LOGFILE"

apply_opacity() {
    local win_id="$1"
    win_name=$(xdotool getwindowname "$win_id" 2>>"$LOGFILE" || echo "No idea")
    geometry=$(xwininfo -id "$win_id" 2>>"$LOGFILE" | grep "Absolute upper-left X" | awk '{print $4}' || echo "Not sure")
    current_opacity=$(xprop -id "$win_id" _NET_WM_WINDOW_OPACITY 2>>"$LOGFILE" | grep -o "0x[0-9a-fA-F]\+" || echo "nothing")
    echo "Checking window ID: $win_id, name: $win_name, X spot: $geometry, opacity now: $current_opacity" >> "$LOGFILE"

    if [ "$current_opacity" != "$opacity" ]; then
        echo "Yo, putting opacity on $win_id..." >> "$LOGFILE"
        xprop -id "$win_id" -f _NET_WM_WINDOW_OPACITY 32c -set _NET_WM_WINDOW_OPACITY "$opacity" 2>>"$LOGFILE"
        if [ $? -eq 0 ]; then
            echo "Nice, opacity set for $win_id ($win_name) at X: $geometry, all good!" >> "$LOGFILE"
            return 0
        else
            echo "Oops, didn’t work for $win_id ($win_name), trying another way..." >> "$LOGFILE"
            xprop -root -f _NET_WM_WINDOW_OPACITY 32c -set _NET_WM_WINDOW_OPACITY "$opacity" -id "$win_id" 2>>"$LOGFILE"
            if [ $? -eq 0 ]; then
                echo "Got it, forced opacity for $win_id ($win_name), sweet!" >> "$LOGFILE"
                return 0
            else
                echo "Still no luck for $win_id ($win_name), what a mess!" >> "$LOGFILE"
                kwin_x11 --replace & 2>>"$LOGFILE"
                sleep 2
                xprop -id "$win_id" -f _NET_WM_WINDOW_OPACITY 32c -set _NET_WM_WINDOW_OPACITY "$opacity" 2>>"$LOGFILE"
                if [ $? -eq 0 ]; then
                    echo "Finally worked after restarting kwin for $win_id ($win_name), yay!" >> "$LOGFILE"
                    return 0
                else
                    echo "Man, everything failed for $win_id ($win_name), so annoying!" >> "$LOGFILE"
                    return 1
                fi
            fi
        fi
    else
        echo "Opacity is already fine for $win_id ($win_name), skipping it..." >> "$LOGFILE"
        return 0
    fi
}

declare -A processed
processed["Brave-browser"]=false
processed["Google-chrome"]=false
processed["TelegramDesktop"]=false
processed["kwrite"]=false
processed["org.remmina.Remmina"]=false
processed["xdg-desktop-portal-kde"]=false

while true; do
    WINDOW_IDS=""
    [ "${processed["Brave-browser"]}" = false ] && BRAVE_IDS=$(xdotool search --class "Brave-browser" 2>>"$LOGFILE") && WINDOW_IDS="$WINDOW_IDS $BRAVE_IDS"
    [ "${processed["Google-chrome"]}" = false ] && CHROME_IDS=$(xdotool search --class "Google-chrome" 2>>"$LOGFILE") && WINDOW_IDS="$WINDOW_IDS $CHROME_IDS"
    [ "${processed["TelegramDesktop"]}" = false ] && TELEGRAM_IDS=$(xdotool search --class "TelegramDesktop" 2>>"$LOGFILE") && WINDOW_IDS="$WINDOW_IDS $TELEGRAM_IDS"
    [ "${processed["kwrite"]}" = false ] && KWRITE_IDS=$(xdotool search --class "kwrite" 2>>"$LOGFILE") && WINDOW_IDS="$WINDOW_IDS $KWRITE_IDS"
    [ "${processed["org.remmina.Remmina"]}" = false ] && REMMINA_IDS=$(xdotool search --class "org.remmina.Remmina" 2>>"$LOGFILE") && WINDOW_IDS="$WINDOW_IDS $REMMINA_IDS"
    [ "${processed["xdg-desktop-portal-kde"]}" = false ] && PORTAL_IDS=$(xdotool search --class "xdg-desktop-portal-kde" 2>>"$LOGFILE") && WINDOW_IDS="$WINDOW_IDS $PORTAL_IDS"

    if [ -z "$WINDOW_IDS" ]; then
        echo "No new app windows found at $(date), just waiting..." >> "$LOGFILE"
        all_done=true
        for class in "${!processed[@]}"; do
            if [ "${processed[$class]}" = false ]; then
                all_done=false
                break
            fi
        done
        if [ "$all_done" = true ]; then
            echo "All apps are done at $(date), see ya!" >> "$LOGFILE"
            exit 0
        fi
        sleep 5
        continue
    fi

    echo "Found some app windows at $(date), let’s go!" >> "$LOGFILE"
    for win_id in $WINDOW_IDS; do
        apply_opacity "$win_id"
        if [ $? -eq 0 ]; then
            for class in "Brave-browser" "Google-chrome" "TelegramDesktop" "kwrite" "org.remmina.Remmina" "xdg-desktop-portal-kde"; do
                if xdotool search --class "$class" | grep -q "$win_id"; then
                    processed["$class"]=true
                    echo "$class is done, nice one!" >> "$LOGFILE"
                    break
                fi
            done
        fi
    done

    all_done=true
    for class in "${!processed[@]}"; do
        if [ "${processed[$class]}" = false ]; then
            all_done=false
            break
        fi
    done
    if [ "$all_done" = true ]; then
        echo "Everything’s finished at $(date), time to relax!" >> "$LOGFILE"
        exit 0
    fi

    echo "Waiting for the rest at $(date)..." >> "$LOGFILE"
    sleep 5
done
