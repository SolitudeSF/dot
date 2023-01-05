from macros import error
import os

type Compiler = enum gcc = "gcc", clang = "clang"

var cross = block:
  const cross {.booldefine.} = false
  cross

const strip {.booldefine.} = true

proc setCompiler(s: string, compiler = gcc, cpp = false) {.used.} =
  let c = findExe s
  let cpp = (if cpp: ".cpp" else: "")
  if c.len == 0:
    error s & " binary wasn't found in $PATH."
  switch $compiler & cpp & ".exe", c
  switch $compiler & cpp & ".linkerexe", c

if defined(musl):
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

if defined(release) or defined(danger):
  if not cross:
    switch "passC", "-march=native"
  switch "passC", "-floop-interchange -ftree-loop-distribution -floop-strip-mine -floop-block"
  switch "passC", "-ftree-vectorize"
  switch "passC", "-flto=auto"
  switch "passL", "-flto=auto"
  switch "passL", "-fuse-linker-plugin"
  if strip:
    switch "passL", "-s"

if defined(libbacktrace):
  switch "stacktrace", "off"
  switch "d", "nimStackTraceOverride"
  switch "import", "libbacktrace"

if defined(danger):
  switch "panics", "on"

if defined(hotcodereloading):
  switch "nimcache", "nimcache"
elif defined(danger):
  switch "nimcache", getTempDir() / "nim" / projectName() & "_d"
elif defined(release):
  switch "nimcache", getTempDir() / "nim" / projectName() & "_r"
else:
  switch "nimcache", getTempDir() / "nim" / projectName()

switch "spellsuggest"
switch "hyperlink"
switch "styleCheck", "usages"
switch "hint", "Dependency:on"
switch "hint", "MsgOrigin:off"
switch "processing", "filenames"

# Way of Nim
# --gc:orc
# --experimental:strictEffects
--experimental:unicodeOperators
# --experimental:overloadableEnums
--define:nimPreviewDotLikeOps
--define:nimPreviewFloatRoundtrip
--define:nimStrictDelete
