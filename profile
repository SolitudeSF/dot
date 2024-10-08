#!/bin/sh
XDG_DATA_HOME=$HOME/.local/share
XDG_STATE_HOME=$HOME/.local/state
XDG_CACHE_HOME=$HOME/.local/cache
XDG_CONFIG_HOME=$HOME/.local/etc
XDG_RUNTIME_DIR=/run/user/$(id -u)
XBPS_DISTDIR=$HOME/git/void-packages
DOTS_DIR=$HOME/dot
GOPATH=$XDG_DATA_HOME/go
CARGO_HOME=$XDG_DATA_HOME/cargo
GRADLE_USER_HOME=$XDG_DATA_HOME/gradle

PATH=$HOME/.local/bin:$DOTS_DIR/bin:$HOME/.nimble/bin:$CARGO_HOME/bin:$GOPATH/bin:$PATH

EDITOR=kak
VISUAL=kak

NO_AT_BRIDGE=1
DBUS_SESSION_BUS_ADDRESS="unix:path=$XDG_RUNTIME_DIR/bus"
SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/ssh.agent
GNUPGHOME=$XDG_DATA_HOME/gnupg
GPG_TTY=$(tty)
NPM_CONFIG_USERCONFIG=$XDG_CONFIG_HOME/npm/npmrc
RUSTUP_HOME=$XDG_DATA_HOME/rustup

unset LS_COLORS

export \
 XDG_DATA_HOME XDG_RUNTIME_DIR XDG_CACHE_HOME XDG_CONFIG_HOME XDG_STATE_HOME \
 XBPS_DISTDIR DOTS_DIR TERMINAL EDITOR VISUAL GOPATH CARGO_HOME RUSTUP_HOME \
 SSH_AUTH_SOCK GPG_TTY GPG_AGENT_INFO GNUPGHOME NO_AT_BRIDGE NPM_CONFIG_USERCONFIG GRADLE_USER_HOME \
 DBUS_SESSION_BUS_ADDRESS

if [ "$GPG_TTY" = /dev/tty1 ]; then
	GTK2_RC_FILES=$XDG_CONFIG_HOME/gtk-2.0/gtkrc
	QT_QPA_PLATFORMTHEME=qt6ct
	TERMINAL='kitty -1'
	_JAVA_AWT_WM_NONREPARENTING=1
	_JAVA_OPTIONS="-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java -Djavafx.cachedir=$XDG_CACHE_HOME/openjfx -Dawt.useSystemAAFontSettings=on -Dswing.aatext=true"
	XCOMPOSEFILE=$XDG_CONFIG_HOME/X11/xcompose
	export \
	 _JAVA_AWT_WM_NONREPARENTING _JAVA_OPTIONS QT_QPA_PLATFORMTHEME \
	 GTK2_RC_FILES TERMINAL XCOMPOSEFILE

	exec dinit
fi
exec elvish
