conf = (get-env XDG_CONFIG_HOME)
dot = (get-env DOTS_DIR)
ntrtmp = $conf/ntr/templates
setini = ['-e' 'set buffer filetype ini']
fn e [@a]{ kak $@a }

fn profile { e $E:HOME/.profile }
fn sx { e $conf/sx/sxrc }
fn git { e $conf/git/config }
fn xbps-src { e -e 'set buffer filetype sh' $E:XBPS_DISTDIR/etc/conf }
fn bspwm { e $conf/bspwm/bspwmrc }
fn sxhkd { e $conf/sxhkd/sxhkdrc; pkill -USR1 -x sxhkd }
fn polybar { e $ntrtmp/polybar }
fn rofi { e $conf/rofi/config.rasi }
fn dunst { e $ntrtmp/dunst }
fn elvish { pwd=~/.elvish e (fd . -L -e elv | fzy) }
fn nim { e $conf/nim/config.nims }
fn min { e $E:HOME/.minrc }
fn ntr { pwd=$conf/ntr e (fd . -L | fzy) }
fn splug { e $conf/splug/config.toml }
fn kitty { e $@setini $conf/kitty/kitty.conf }
fn kitty-diff { e $@setini $conf/kitty/diff.conf }
fn kitty-colors { e $@setini $dot/ntr/templates/kitty-colors }
fn ranger { e $conf/ranger/rc.conf }
fn rifle { e $conf/ranger/rifle.conf }
fn kak { e $conf/kak/kakrc }
fn pqiv { e $conf/pqivrc }
fn mpv { e $conf/mpv/mpv.conf }
fn ncmpcpp { e $@setini $conf/ncmpcpp/config }
fn bedrock { e /bedrock/etc/bedrock.conf }
