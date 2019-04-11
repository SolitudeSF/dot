xrdb -nocpp "$HOME/.Xresources"
xsetroot -cursor_name left_ptr &
setxkbmap -layout us,ru -variant ,ruu -option 'grp:shift_caps_toggle,grp_led:scroll,lv3:ralt_switch,compose:rwin-altgr,nbsp:level3' &
start-pulseaudio-x11 &
wlp &
mpd &
dunst &
perWindowLayoutD &
disown sxhkd &
disown devmon -s \
 --exec-on-drive 'notify-send -a udevil -i media-removable "$l" "$f mounted at $d"' \
 --exec-on-unmount 'notify-send -a udevil -i media-removable "$l" "$f unmounted from $d"' \
 --exec-on-remove 'notify-send -a udevil -i media-removable "$l" "$f removed from $d"' &
disown syncthing -no-browser &
disown polybar -q main &
exec bspwm
