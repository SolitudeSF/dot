use str

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
    branch = [(str:split ' ' $data[1])][2]

    if (and (> (count $data) 3) (str:has-prefix $data[3] '# branch.ab')) {
      ahead behind = (all [(str:split ' ' $data[3])][2..])[1..]
    }

    for i $data {
      if (or (str:has-prefix $i 1) (str:has-prefix $i 2)) {
        if (eq $i[2] '.') {
          dirty = (+ $dirty 1)
        } else {
          staged = (+ $staged 1)
        }
      } elif (str:has-prefix $i '?') {
        untracked = (+ $untracked 1)
      }
    }
  )
}
