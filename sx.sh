xrandr --output DisplayPort-1 --primary
xrandr --output HDMI-A-0 --auto --left-of DisplayPort-1

xrdb -nocpp "$XDG_CONFIG_HOME/X11/xresources" &
dbus-update-activation-environment DISPLAY XAUTHORITY
xsetroot -cursor_name left_ptr &
xkbcomp "$DOTS_DIR/layout.xkb" "$DISPLAY" &
picom -b &
detach pipewire &
wlp &
mpd &
perWindowLayoutD &
detach sxhkd -m 1 &
detach unclutter &
detach strat void /usr/libexec/polkit-mate-authentication-agent-1 &
detach syncthing -no-browser &
exec bspwm
