use util

start = (date +%s)
delta = 0
s = 0
m = 0
h = 0

util:add-after-readline [_]{ start = (date +%s) }
util:add-before-readline {
  delta = (- (date +%s) $start)
  if (> $delta 3600) {
    s = (% $delta 60)
    m = (/ (- (% $delta 3600) $s) 60)
    h = (/ (- $delta (* $m 60) $s) 3600)
  } elif (> $delta 60) {
    s = (% $delta 60)
    m = (/ (- $delta $s) 60)
    h = 0
  } else {
    s = $delta
    m = 0
    h = 0
  }
}

fn display {
  if (> $h 0) {
    styled ' ⏱'$h':'(util:pad $m 2 &with=0)':'(util:pad $s 2 &with=0) bold
  } elif (> $m 0) {
    styled ' ⏱'$m':'(util:pad $s 2 &with=0) bold
  } elif (> $s 5) {
    styled ' ⏱'$s bold
  }
}
