fn calc [@a]{
  s = []

  for x $a {
    if (eq $x '+') {
      s = [(+ $@s)]
    } elif (or (eq $x '*') (eq $x 'x')) {
      s = [(* $@s)]
    } elif (eq $x '-') {
      i = (- $s[-2] $s[-1])
      s = [(put $@s | take (- (count $s) 2)) $i]
    } elif (eq $x '/') {
      i = (/ $s[-2] $s[-1])
      s = [(put $@s | take (- (count $s) 2)) $i]
    } else {
      s = [$@s $x]
    }
  }

  put $@s
}
