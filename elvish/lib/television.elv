use store

fn smart-autocomplete {
  var pre-prompt = $edit:current-command[..$edit:-dot]
  if (not (== (count $pre-prompt) 0)) {
    var output = (var error = ?(tv --autocomplete-prompt $pre-prompt 2>/dev/tty </dev/tty))
    if (and $error (not (== (count $output) 0))) {
        if (not (==s $pre-prompt[-1] ' ')) {
          set pre-prompt = $pre-prompt" "
        }
        set edit:current-command = $pre-prompt$output$edit:current-command[$edit:-dot..]
    }
  }
}

fn shell-history {
  var pre-prompt = $edit:current-command[..$edit:-dot]
  var output = (var error = ?(store:cmds 0 -1 | each {|x| echo $x[text] } | tv --input $pre-prompt 2>/dev/tty </dev/tty))
  if (and $error (not (== (count $output) 0))) {
    set edit:current-command = $output$edit:current-command[$edit:-dot..]
  }
}
