xrdb -nocpp "$HOME/.Xresources" &
dbus-update-activation-environment DISPLAY XAUTHORITY
xsetroot -cursor_name left_ptr &
xkbcomp "$DOTS_DIR/layout.xkb" "$DISPLAY" &
disown pipewire &
wlp &
mpd &
perWindowLayoutD &
disown sxhkd &
disown unclutter &
disown /usr/libexec/xfce-polkit &
disown syncthing -no-browser &
exec bspwm
