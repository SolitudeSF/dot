var conf = $E:XDG_CONFIG_HOME
var dot = $E:DOTS_DIR
var ntrtmp = $conf/ntr/templates

fn select {|@a|
  e:f -L -t=f $@a | sk --height=35% --layout=reverse -m
}

fn edit {|&type='' @a|
  var settype = []
  if (not-eq $type '') {
    set settype = ['-e' 'set buffer filetype '$type]
  }
  kak $@settype $@a
}

fn profile { edit $E:HOME/.profile }
fn git { edit $conf/git/config }
fn xbps-src { edit &type=sh $E:XBPS_DISTDIR/etc/conf }
fn bspwm { edit &type=sh $conf/bspwm/bspwmrc }
fn sxhkd { edit $conf/sxhkd/sxhkdrc; dinitctl signal USR1 sxhkd }
fn polybar { edit $conf/polybar/config.ini; dinitctl signal USR1 polybar-main }
fn rofi { edit &type=css $conf/rofi/config.rasi }
fn dunst { edit $ntrtmp/dunst }
fn elvish { tmp pwd = $conf/elvish; edit (select '.elv') }
fn nim { edit $conf/nim/config.nims }
fn min { edit $E:HOME/.minrc }
fn ntr { tmp pwd = $conf/ntr; edit (select) }
fn splug { edit $conf/splug/config.toml }
fn kitty { tmp pwd = $conf/kitty; edit &type=ini (select) }
fn kitty-colors { edit &type=ini $dot/ntr/templates/kitty-colors }
fn yazi { tmp pwd = $conf/yazi; edit (select) }
fn lc { edit $conf/lc/config }
fn kak { edit $conf/kak/kakrc }
fn pqiv { edit $conf/pqivrc }
fn mpv { tmp pwd = $conf/mpv; edit (select '.conf') }
fn mpwc { edit $conf/mpwc/(cat ~/sns/mpwname).mpsites }
fn ncmpcpp { edit &type=ini $conf/ncmpcpp/config }
fn bedrock { edit /bedrock/etc/bedrock.conf; sudo brl apply }
fn homepage { edit $dot/firefox/homepage.nims; e:nim e -p:$E:HOME/sns/ $dot/firefox/homepage.nims >~/.mozilla/firefox/homepage.html }
fn layout { edit $dot/layout.xkb; xkbcomp $dot/layout.xkb $E:DISPLAY }
fn dinit { tmp pwd = $conf/dinit.d; edit (select) }
fn hyprland { edit $conf/hypr/hyprland.conf }
