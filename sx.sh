xrdb -nocpp "$XDG_CONFIG_HOME/X11/xresources" &
dbus-update-activation-environment DISPLAY XAUTHORITY
xsetroot -cursor_name left_ptr &
xkbcomp "$DOTS_DIR/layout.xkb" "$DISPLAY" &
detach strat arch pipewire &
wlp &
mpd &
perWindowLayoutD &
detach sxhkd &
detach unclutter &
detach strat artix /usr/lib/mate-polkit/polkit-mate-authentication-agent-1 &
detach syncthing -no-browser &
exec bspwm
