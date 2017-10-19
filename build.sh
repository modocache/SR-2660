set -e
set -x

SWIFTC="$HOME/local/Source/apple/build/Ninja-ReleaseAssert/swift-macosx-x86_64/bin/swiftc"
SWIFT_SDK="$(xcode-select -p)/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.13.sdk"
SWIFT_LIB="$(xcode-select -p)/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift/macosx"
CLANG="$HOME/local/Source/apple/build/Ninja-ReleaseAssert/llvm-macosx-x86_64/bin/clang"
LLDB="$HOME/local/Source/apple/build/Ninja-ReleaseAssert/lldb-macosx-x86_64/CustomSwift-Release/lldb"

mkdir -p out

# Build Swift modules with debug info.
$SWIFTC -c -g src/foo.swift \
  -target x86_64-apple-macosx10.12 \
  -sdk "$SWIFT_SDK" \
  -parse-as-library \
  -module-name Foo \
  -emit-module-path out/Foo.swiftmodule \
  -emit-objc-header-path out/Foo-Swift.h \
  -output-file-map output_map.json

$SWIFTC -c -g src/bar.swift \
  -target x86_64-apple-macosx10.12 \
  -sdk "$SWIFT_SDK" \
  -parse-as-library \
  -module-name Bar \
  -emit-module-path out/Bar.swiftmodule \
  -emit-objc-header-path out/Bar-Swift.h \
  -output-file-map output_map.json

# Build the main program, without using dSYM.
$CLANG src/main.m -fobjc-arc -o out/main out/foo.o out/bar.o \
  -isysroot "$SWIFT_SDK" \
  -Iout \
  -L"$SWIFT_LIB" \
  -Xlinker -rpath -Xlinker "$SWIFT_LIB" \
  -Xlinker -add_ast_path -Xlinker out/Foo.swiftmodule \
  -Xlinker -add_ast_path -Xlinker out/Bar.swiftmodule

# Run LLDB commands.
$LLDB out/main -b -s lldb_commands.txt
