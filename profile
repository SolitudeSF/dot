# Set common directories
XDG_DATA_HOME=$HOME/.local/share
XDG_CACHE_HOME=$HOME/.local/cache
XDG_CONFIG_HOME=$HOME/.local/etc
XDG_RUNTIME_DIR=/tmp/runtime-$USER
XBPS_DISTDIR=$HOME/git/void-packages
DOTS_DIR=$HOME/dot
GOPATH=$XDG_DATA_HOME/go
CARGO_HOME=$XDG_DATA_HOME/cargo

mkdir -p $XDG_RUNTIME_DIR

# Override system variables
PATH=$HOME/.local/bin:$DOTS_DIR/bin:$HOME/.nimble/bin:$CARGO_HOME/bin:$GOPATH/bin:$PATH

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

_JAVA_AWT_WM_NONREPARENTING=1
_JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true'

unset LS_COLORS

# Mass export
export \
 XDG_DATA_HOME XDG_RUNTIME_DIR XDG_CACHE_HOME XDG_CONFIG_HOME XDG_RUNTIME_DIR \
 XBPS_DISTDIR DOTS_DIR GTK2_RC_FILES LESSHISTFILE TERMINAL EDITOR VISUAL \
 PAGER MANPAGER GPG_TTY GPG_AGENT_INFO GNUPGHOME QT_QPA_PLATFORMTHEME \
 _JAVA_AWT_WM_NONREPARENTING _JAVA_OPTIONS GOPATH CARGO_HOME

# Init sharable {ssh,gpg}-agent
if [ -z "$SSH_AUTH_SOCK" ]; then
	if ! pgrep -xu "$(id -u)" gpg-agent >/dev/null; then
		gpg-agent -q --daemon >"$XDG_CACHE_HOME/ssh-env"
	fi
	. "$XDG_CACHE_HOME/ssh-env"
fi

# Sensitive info
. $HOME/sns/profile

# Start X or shell
if [ "$GPG_TTY" = /dev/tty1 ]; then
	exec dbus-launch sx
fi
exec elvish
