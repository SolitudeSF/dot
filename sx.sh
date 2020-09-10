xrdb -nocpp "$HOME/.Xresources" &
dbus-update-activation-environment DISPLAY XAUTHORITY
xsetroot -cursor_name left_ptr &
xkbcomp "$DOTS_DIR/layout.xkb" "$DISPLAY" &
wlp &
mpd &
perWindowLayoutD &
disown sxhkd &
disown unclutter &
disown /usr/libexec/xfce-polkit &
disown syncthing -no-browser &
disown polybar -q main &
disown polybar -q secondary &
disown devmon -s \
 --exec-on-drive 'notify-send -a udevil -i media-removable "$l" "$f mounted at $d"' \
 --exec-on-unmount 'notify-send -a udevil -i media-removable "$l" "$f unmounted from $d"' \
 --exec-on-remove 'notify-send -a udevil -i media-removable "$l" "$f removed from $d"' &
exec bspwm
