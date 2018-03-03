from macros import error

switch "styleCheck", "hint"

proc setCompiler(s: string) =
  let c = findExe s
  if c.len == 0:
    error s & " binary wasn't found in $PATH."
  switch "gcc.exe", c
  switch "gcc.linkerexe", c

when defined(win):
  setCompiler "x86_64-w64-mingw32-gcc"
  switch "gcc.options.linker", ""
  switch "os", "windows"
  switch "define", "windows"

when defined(musl):
  setCompiler "x86_64-linux-musl-gcc"
  switch "passL", "-static"

when defined(release):
  switch "nimcache", "/tmp/nim/" & projectName() & "/r"
  switch "passC", "-flto"
  switch "passL", "-s"
else:
  switch "nimcache", "/tmp/nim/" & projectName() & "/d"
