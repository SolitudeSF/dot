var conf = $E:XDG_CONFIG_HOME
var dot = $E:HOME/dot
var ntrtmp = $conf/ntr/templates

fn select {|@a| e:f -L -t=f $@a | tv }
fn edit {|@a| kak $@a }

fn profile { edit $E:HOME/.profile }
fn git { edit $conf/git/config }
fn bspwm { edit $conf/bspwm/bspwmrc }
fn sxhkd { edit $conf/sxhkd/sxhkdrc; systemctl --user reload sxhkd }
fn polybar { edit $conf/polybar/config.ini; systemctl --user reload polybar@main }
fn rofi { edit $conf/rofi/config.rasi }
fn dunst { edit $ntrtmp/dunst }
fn elvish { tmp pwd = $conf/elvish; edit (select '.elv') }
fn nim { edit $conf/nim/config.nims }
fn ntr { tmp pwd = $conf/ntr; edit (select) }
fn splug { edit $conf/splug/config.toml }
fn kitty { tmp pwd = $conf/kitty; edit (select) }
fn kitty-colors { edit $ntrtmp/kitty-colors }
fn yazi { tmp pwd = $conf/yazi; edit (select) }
fn lc { edit $conf/lc/config }
fn kak { edit $conf/kak/kakrc }
fn mpv { tmp pwd = $conf/mpv; edit (select '.conf') }
fn mpwc { edit $conf/mpwc/(slurp <~/sns/mpwname).mpsites }
fn bedrock { edit /bedrock/etc/bedrock.conf; sudo brl apply }
fn homepage { edit ~/sns/homepageData.nim; e:nim e -p:$E:HOME/sns/ $dot/firefox/homepage.nims >~/.floorp/homepage.html }
fn layout { edit $dot/layout.xkb; xkbcomp $dot/layout.xkb $E:DISPLAY }
fn systemd { tmp pwd = $conf/systemd/user; edit (select) }
fn hyprland { edit $conf/hypr/hyprland.conf }
fn rmpc { edit $conf/rmpc/config.ron }
fn nushell { tmp pwd = $conf/nushell; edit (select '.nu') }
