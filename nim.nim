from macros import error

type Compiler = enum gcc = "gcc", clang = "clang"

proc setCompiler(s: string, compiler = gcc, cpp = false) {.used.} =
  let c = findExe s
  let cpp = (if cpp: ".cpp" else: "")
  if c.len == 0:
    error s & " binary wasn't found in $PATH."
  switch $compiler & cpp & ".exe", c
  switch $compiler & cpp & ".linkerexe", c

when defined(wasm):
  let linkerOptions = "-nostdlib -Wl,--no-entry,--allow-undefined,--gc-sections,--strip-all"
  switch "o", projectName() & ".wasm"
  switch "cpu", "i386"
  switch "cc", "clang"
  switch "d", "release"
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

when defined(musl):
  setCompiler "x86_64-linux-musl-gcc"
  switch "passL", "-static"

when defined(release) or defined(danger):
  switch "excessiveStackTrace", "off"
  switch "passC", "-march=native -O3"
  switch "passC", "-floop-interchange -ftree-loop-distribution -floop-strip-mine -floop-block"
  switch "passC", "-flto=8"
  switch "passC", "-ftree-vectorize"
  switch "passL", "-fuse-linker-plugin"
  switch "passL", "-s"

when defined(danger):
  switch "nimcache", "/tmp/nim/" & projectName() & "_d"
elif defined(release):
  switch "nimcache", "/tmp/nim/" & projectName() & "_r"
else:
  switch "nimcache", "/tmp/nim/" & projectName()

when defined(hotcodereloading):
  switch "nimcache", "nimcache"

switch "styleCheck", "hint"
switch "parallelBuild", "0"
