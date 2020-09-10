conf = $E:XDG_CONFIG_HOME
dot = $E:DOTS_DIR
ntrtmp = $conf/ntr/templates

fn select [@a]{
  fd . -L -t f $@a | sk --height=35% --layout=reverse -m
}

fn edit [&type='' @a]{
  settype = []
  if (not-eq $type '') {
    settype = ['-e' 'set buffer filetype '$type]
  }
  kak $@settype $@a
}

fn profile { edit $E:HOME/.profile }
fn sx { edit &type=sh $conf/sx/sxrc }
fn git { edit $conf/git/config }
fn xbps-src { edit &type=sh $E:XBPS_DISTDIR/etc/conf }
fn bspwm { edit &type=sh $conf/bspwm/bspwmrc }
fn sxhkd { edit $conf/sxhkd/sxhkdrc; pkill -USR1 -x sxhkd }
fn polybar { edit $ntrtmp/polybar }
fn rofi { edit &type=css $conf/rofi/config.rasi }
fn dunst { edit $ntrtmp/dunst }
fn elvish { pwd=~/.elvish edit (select -e elv) }
fn nim { edit $conf/nim/config.nims }
fn min { edit $E:HOME/.minrc }
fn ntr { pwd=$conf/ntr edit (select) }
fn splug { edit $conf/splug/config.toml }
fn kitty { edit &type=ini $conf/kitty/kitty.conf }
fn kitty-diff { edit &type=ini $conf/kitty/diff.conf }
fn kitty-colors { edit &type=ini $dot/ntr/templates/kitty-colors }
fn ranger { edit $conf/ranger/rc.conf }
fn rifle { edit $conf/ranger/rifle.conf }
fn lc { edit $conf/lc/config }
fn kak { edit $conf/kak/kakrc }
fn pqiv { edit $conf/pqivrc }
fn mpv { edit $conf/mpv/mpv.conf }
fn mpwc { edit $conf/mpwc/(cat ~/sns/mpwname).mpsites }
fn ncmpcpp { edit &type=ini $conf/ncmpcpp/config }
fn bedrock { edit /bedrock/etc/bedrock.conf; sudo brl apply }
fn homepage { edit $dot/firefox/homepage.nims; e:nim e -p:$E:HOME/sns/ $dot/firefox/homepage.nims >~/.mozilla/firefox/homepage.html }
fn layout { edit $dot/layout.xkb; xkbcomp $dot/layout.xkb $E:DISPLAY }
