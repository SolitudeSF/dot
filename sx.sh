xrdb -nocpp "$HOME/.Xresources"
xsetroot -cursor_name left_ptr &
setxkbmap -layout us,ru -variant ,ruu -option 'grp:shifts_toggle,grp:shift_caps_toggle,grp_led:scroll,lv3:ralt_switch,compose:rwin-altgr,nbsp:level3' &
start-pulseaudio-x11 &
setroot --restore &
mpd &
sxhkd &
devmon &
dunst &
emacs --daemon &
kbdd &
polybar -q main &
exec bspwm
