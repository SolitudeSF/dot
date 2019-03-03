from macros import error

switch "styleCheck", "hint"

proc setCompiler(s: string) =
  let c = findExe s
  if c.len == 0:
    error s & " binary wasn't found in $PATH."
  switch "gcc.exe", c
  switch "gcc.linkerexe", c

when defined(musl):
  setCompiler "x86_64-linux-musl-gcc"
  switch "passL", "-static"

when defined(release):
  switch "nimcache", "/tmp/nim/" & projectName() & "_r"
  switch "passC", "-flto"
  switch "passL", "-s"
else:
  switch "nimcache", "/tmp/nim/" & projectName() & "_d"
