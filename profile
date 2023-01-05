# Set common directories

XDG_DATA_HOME=$HOME/.local/share
XDG_STATE_HOME=$HOME/.local/state
XDG_CACHE_HOME=$HOME/.local/cache
XDG_CONFIG_HOME=$HOME/.local/etc
XDG_RUNTIME_DIR=/tmp/runtime-$USER
XBPS_DISTDIR=$HOME/git/void-packages
DOTS_DIR=$HOME/dot
GOPATH=$XDG_DATA_HOME/go
CARGO_HOME=$XDG_DATA_HOME/cargo
GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle

mkdir -p -m=0700 "$XDG_RUNTIME_DIR"

# Override system variables
PATH=$HOME/.local/bin:$DOTS_DIR/bin:$HOME/.nimble/bin:$CARGO_HOME/bin:$GOPATH/bin:$PATH

GPG_TTY=$(tty)
EDITOR=kak
VISUAL=kak

NO_AT_BRIDGE=1
GNUPGHOME=$XDG_DATA_HOME/gnupg
GPG_AGENT_INFO=$XDG_RUNTIME_DIR/S.gpg-agent::1
NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc
RUSTUP_HOME=$XDG_DATA_HOME/rustup

unset LS_COLORS

export \
 XDG_DATA_HOME XDG_RUNTIME_DIR XDG_CACHE_HOME XDG_CONFIG_HOME XDG_STATE_HOME \
 XBPS_DISTDIR DOTS_DIR TERMINAL EDITOR VISUAL GOPATH CARGO_HOME RUSTUP_HOME \
 GPG_TTY GPG_AGENT_INFO GNUPGHOME NO_AT_BRIDGE NPM_CONFIG_USERCONFIG GRADLE_USER_HOME

# Init sharable {ssh,gpg}-agent
UID=$(id -u)
pgrep -xu "$UID" gpg-agent || gpg-agent -q --daemon
pgrep -xu "$UID" ssh-agent || ssh-agent >"$XDG_RUNTIME_DIR/ssh-env"
. "$XDG_RUNTIME_DIR/ssh-env"

# Start X or shell
if [ "$GPG_TTY" = /dev/tty1 ]; then
	GTK2_RC_FILES=$XDG_CONFIG_HOME/gtk-2.0/gtkrc
	QT_QPA_PLATFORMTHEME=gtk2
	TERMINAL='kitty -1'
	_JAVA_AWT_WM_NONREPARENTING=1
	_JAVA_OPTIONS="-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java -Dawt.useSystemAAFontSettings=on -Dswing.aatext=true"
	XCOMPOSEFILE="$XDG_CONFIG_HOME"/X11/xcompose
	export \
	 _JAVA_AWT_WM_NONREPARENTING _JAVA_OPTIONS QT_QPA_PLATFORMTHEME \
	 GTK2_RC_FILES TERMINAL XCOMPOSEFILE

	exec dbus-launch sx
fi
exec elvish
