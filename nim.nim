from macros import error

type Compiler = enum gcc = "gcc", clang = "clang"

var cross {.used.} = false

proc setCompiler(s: string, compiler = gcc, cpp = false) {.used.} =
  let c = findExe s
  let cpp = (if cpp: ".cpp" else: "")
  if c.len == 0:
    error s & " binary wasn't found in $PATH."
  switch $compiler & cpp & ".exe", c
  switch $compiler & cpp & ".linkerexe", c

when defined(musl):
  setCompiler "x86_64-linux-musl-gcc"

elif defined(x86):
  cross = true
  setCompiler "i686-pc-linux-gnu-gcc"
  switch "cpu", "i386"
  switch "passL", "--sysroot=/usr/i686-pc-linux-gnu/"

elif defined(arm):
  cross = true
  switch "cpu", "arm"
  switch "passL", "--sysroot=/usr/arm-linux-gnueabihf/"

elif defined(wasm):
  cross = true
  let linkerOptions = "-nostdlib -Wl,--no-entry,--allow-undefined,--gc-sections,--strip-all"
  switch "o", projectName() & ".wasm"
  switch "cpu", "i386"
  switch "cc", "clang"
  switch "d", "danger"
  switch "opt", "size"
  switch "stackTrace", "off"
  switch "nomain"
  switch "d", "nimNoLibc"
  switch "d", "noSignalHandler"
  switch "passC", "--target=wasm32-unknown-unknown-wasm"
  switch "passC", "-mexception-handling"
  switch "passC", "-nostdlib"
  switch "passL", "--target=wasm32-unknown-unknown-wasm"
  switch "clang.options.linker", linkerOptions
  switch "clang.cpp.options.linker", linkerOptions

when defined(release) or defined(danger):
  switch "excessiveStackTrace", "off"
  if not cross:
    switch "passC", "-march=native"
  switch "passC", "-floop-interchange -ftree-loop-distribution -floop-strip-mine -floop-block"
  switch "passC", "-ftree-vectorize"
  switch "passC", "-flto"
  switch "passL", "-flto"
  switch "passL", "-fuse-linker-plugin"
  switch "passL", "-s"

when defined(danger):
  switch "panics", "on"

when defined(hotcodereloading):
  switch "nimcache", "nimcache"
elif defined(danger):
  switch "nimcache", "/tmp/nim/" & projectName() & "_d"
elif defined(release):
  switch "nimcache", "/tmp/nim/" & projectName() & "_r"
else:
  switch "nimcache", "/tmp/nim/" & projectName()

switch "styleCheck", "hint"
switch "hint", "Processing:off"
switch "hint", "Dependency:on"
