branch    = ''
dirty     = 0
staged    = 0
untracked = 0
ahead     = 0
behind    = 0

fn refresh-status {
  branch    = ''
  dirty     = 0
  staged    = 0
  untracked = 0
  ahead     = 0
  behind    = 0

  _ = ?(
    @data = (git --no-optional-locks status --ignore-submodules --porcelain=v2 -b 2>&-)
    branch = [(splits ' ' $data[1])][2]

    if (and (> (count $data) 3) (has-prefix $data[3] '# branch.ab')) {
      ahead behind = (all [(splits ' ' $data[3])][2:])[1:]
    }

    for i $data {
      if (or (has-prefix $i 1) (has-prefix $i 2)) {
        if (eq $i[2] '.') {
          dirty = (+ $dirty 1)
        } else {
          staged = (+ $staged 1)
        }
      } elif (has-prefix $i '?') {
        untracked = (+ $untracked 1)
      }
    }
  )
}
