# Set common directories
XDG_DATA_HOME=$HOME/.local/share
XDG_CACHE_HOME=$HOME/.local/cache
XDG_CONFIG_HOME=$HOME/.local/etc
XDG_RUNTIME_DIR=/tmp/runtime-$USER
XBPS_DISTDIR=$HOME/git/void-packages
DOTS_DIR=$HOME/dot
GOPATH=$XDG_DATA_HOME/go
CARGO_HOME=$XDG_DATA_HOME/cargo

mkdir -p "$XDG_RUNTIME_DIR"

# Override system variables
PATH=$HOME/.local/bin:$DOTS_DIR/bin:$HOME/.nimble/bin:$CARGO_HOME/bin:$GOPATH/bin:$PATH

GPG_TTY=$(tty)
TERMINAL='kitty -1'
EDITOR=kak
VISUAL=kak
QT_QPA_PLATFORMTHEME=gtk2

NO_AT_BRIDGE=1
GTK2_RC_FILES=$XDG_CONFIG_HOME/gtk-2.0/gtkrc
GNUPGHOME=$XDG_DATA_HOME/gnupg
GPG_AGENT_INFO=$GNUPGHOME/S.gpg-agent:0:1

_JAVA_AWT_WM_NONREPARENTING=1
_JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true'

unset LS_COLORS

# Mass export
export \
 XDG_DATA_HOME XDG_RUNTIME_DIR XDG_CACHE_HOME XDG_CONFIG_HOME XDG_RUNTIME_DIR \
 XBPS_DISTDIR DOTS_DIR GTK2_RC_FILES TERMINAL EDITOR VISUAL \
 GOPATH CARGO_HOME GPG_TTY GPG_AGENT_INFO GNUPGHOME QT_QPA_PLATFORMTHEME \
 _JAVA_AWT_WM_NONREPARENTING _JAVA_OPTIONS NO_AT_BRIDGE

# Init sharable {ssh,gpg}-agent
pgrep -xu "$(id -u)" gpg-agent || gpg-agent -q --daemon
pgrep -xu "$(id -u)" ssh-agent || ssh-agent >"$XDG_CACHE_HOME/ssh-env"
. "$XDG_CACHE_HOME/ssh-env"

# Start X or shell
if [ "$GPG_TTY" = /dev/tty1 ]; then
	exec sx
fi
exec elvish
