from macros import error

type Compiler = enum gcc = "gcc", clang = "clang"

const is199 = (NimMajor, NimMinor, NimPatch) >= (0, 19, 9)

proc setCompiler(s: string, compiler = gcc, cpp = false) =
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

when is199:
  switch "styleCheck", "hint"

when defined(release):
  when is199:
    switch "nimcache", "/tmp/nim/" & projectName() & "_r"
  switch "passC", "-flto"
  switch "passL", "-s"
elif is199:
  switch "nimcache", "/tmp/nim/" & projectName() & "_d"

when defined(hotcodereloading):
  switch "nimcache", "nimcache"
