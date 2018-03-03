# Set common directories
XDG_DATA_HOME=$HOME/.data
XDG_CACHE_HOME=$HOME/.cache
XDG_CONFIG_HOME=$HOME/.etc
XDG_RUNTIME_DIR=/tmp/runtime-$USER
XBPS_DISTDIR=$HOME/git/void-packages
DOTS_DIR=$HOME/dot

# Override system variables
PATH=$HOME/bin:$HOME/.nimble/bin:$DOTS_DIR/bin:$PATH

GPG_TTY=$(tty)
TERMINAL='kitty -1'
EDITOR=kak
VISUAL=kak
PAGER=less
MANPAGER=less
QT_QPA_PLATFORMTHEME=gtk2

GTK2_RC_FILES=$XDG_CONFIG_HOME/gtk-2.0/gtkrc
LESSHISTFILE="-"
GNUPGHOME=$XDG_DATA_HOME/gnupg
GPG_AGENT_INFO=$GNUPGHOME/S.gpg-agent:0:1
DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/S.dbus"

_JAVA_AWT_WM_NONREPARENTING=1
_JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true'

# Mass export
export \
 XDG_DATA_HOME XDG_RUNTIME_DIR XDG_CACHE_HOME XDG_CONFIG_HOME XDG_RUNTIME_DIR \
 XBPS_DISTDIR DOTS_DIR GTK2_RC_FILES LESSHISTFILE TERMINAL EDITOR VISUAL \
 PAGER MANPAGER GPG_TTY GPG_AGENT_INFO GNUPGHOME QT_QPA_PLATFORMTHEME \
 _JAVA_AWT_WM_NONREPARENTING _JAVA_OPTIONS DBUS_SESSION_BUS_ADDRESS

# Init sharable {ssh,gpg}-agent
if [ -z "$SSH_AUTH_SOCK" ]; then
	if ! pgrep -xu "$(id -u)" gpg-agent >/dev/null; then
		gpg-agent -q --daemon >"$XDG_CACHE_HOME/ssh-env"
	fi
	. "$XDG_CACHE_HOME/ssh-env"
fi

# Start X or shell
if [ -z "$DISPLAY" ] && [ "$GPG_TTY" = /dev/tty1 ]; then
	exec dbus-launch --sh-syntax sx
fi
exec elvish
