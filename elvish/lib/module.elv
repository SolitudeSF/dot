fn exported [a]{
  result = [&]
  keys $a | each [x]{
    result[$x] = $a[$x]
  }
  put $result
}
