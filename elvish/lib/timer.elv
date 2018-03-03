use util

start = (date +%s)
delta = 0
s = 0
m = 0
h = 0
composed = ''

fn pad [a]{ if (< $a 10) { put '0'$a } }

util:add-after-readline [_]{ start = (date +%s) }
util:add-before-readline {
  delta = (- (date +%s) $start)
  h = 0
  m = 0
  s = $delta
  if (> $delta 3600) {
    s = (% $delta 60)
    m = (/ (- (% $delta 3600) $s) 60)
    h = (/ (- $delta (* $m 60) $s) 3600)
    composed = (edit:styled ' ⏱'$h':'(util:pad $m 2 &with=0)':'(util:pad $s 2 &with=0) bold)
  } elif (> $delta 60) {
    s = (% $delta 60)
    m = (/ (- $delta $s) 60)
    composed = (edit:styled ' ⏱'$m':'(util:pad $s 2 &with=0) bold)
  } elif (> $delta 5) {
    composed = (edit:styled ' ⏱'$delta  bold)
  } else {
    composed = ''
  }
}
