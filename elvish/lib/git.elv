use str

var branch    = ''
var dirty     = 0
var staged    = 0
var untracked = 0
var ahead     = 0
var behind    = 0

fn refresh-status {
  set branch    = ''
  set dirty     = 0
  set staged    = 0
  set untracked = 0
  set ahead     = 0
  set behind    = 0

  set _ = ?(
    var @data = (git --no-optional-locks status --ignore-submodules --porcelain=v2 -b 2>&-)
    set branch = [(str:split ' ' $data[1])][2]

    if (and (> (count $data) 3) (str:has-prefix $data[3] '# branch.ab')) {
      set ahead behind = (all [(str:split ' ' $data[3])][2..])[1..]
    }

    for i $data {
      if (or (str:has-prefix $i 1) (str:has-prefix $i 2)) {
        if (eq $i[2] '.') {
          set dirty = (+ $dirty 1)
        } else {
          set staged = (+ $staged 1)
        }
      } elif (str:has-prefix $i '?') {
        set untracked = (+ $untracked 1)
      }
    }
  )
}
