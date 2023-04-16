# https://gitlab.freedesktop.org/Per_Bothner/specifications/blob/master/proposals/semantic-prompts.md

fn prompt-start {|&kind=i|
  put "\e]133;P;k="$kind";\e\\"
}

fn prompt-end {|&kind=i|
  put "\e]133;B;k="$kind";\e\\"
}

fn output-start {
  printf "\e]133;C;\e\\"
}

fn output-end {
  printf "\e]133;A;cl=m;aid="$pid"\e\\"
}
