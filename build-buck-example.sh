set -e
set -x

SWIFTC="$HOME/local/Source/apple/build/Ninja-ReleaseAssert/swift-macosx-x86_64/bin/swiftc"
SWIFT_SDK="$(xcode-select -p)/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.13.sdk"
SWIFT_LIB="$HOME/local/Source/apple/build/Ninja-ReleaseAssert/swift-macosx-x86_64/lib/swift/macosx"
CLANG="$HOME/local/Source/apple/build/Ninja-ReleaseAssert/llvm-macosx-x86_64/bin/clang"
LIBTOOL="/Applications/Xcode_9.0.0_fb.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/libtool"
LLDB="$HOME/local/Source/apple/build/Ninja-ReleaseAssert/lldb-macosx-x86_64/CustomSwift-Release/lldb"

mkdir -p out
mkdir -p Foo.swiftmodule
mkdir -p Bar.swiftmodule
mkdir -p out-static

# Build Swift modules with debug info.
$SWIFTC -c -g buck-example-src/foo.swift \
  -target x86_64-apple-macosx10.12 \
  -sdk "$SWIFT_SDK" \
  -parse-as-library \
  -module-name Foo \
  -emit-module-path Foo.swiftmodule/x86_64.swiftmodule \
  -emit-objc-header-path Foo.swiftmodule/Foo-Swift.h \
  -output-file-map buck-example-output_map.json

$CLANG -g -c buck-example-src/foo.m -o out/foo-m.o \
  -x objective-c \
  -arch x86_64 \
  -std=gnu11 \
  -D_LIBCPP_HAS_NO_STRONG_ENUMS=1 \
  -isysroot "$SWIFT_SDK" \
  -fasm-blocks -fstrict-aliasing \
  -mmacosx-version-min=10.10 \
  -I"Foo.swiftmodule" \
  -fobjc-arc -fno-objc-arc-exceptions -Qunused-arguments

$LIBTOOL Foo.swiftmodule/foo.o out/foo-m.o \
  -static \
  -arch_only x86_64 \
  -syslibroot "$SWIFT_SDK" \
  -L"Foo.swiftmodule" \
  -L"$SWIFT_LIB" \
  -o out-static/libFoo.a

$SWIFTC -c -g buck-example-src/bar.swift \
  -target x86_64-apple-macosx10.12 \
  -sdk "$SWIFT_SDK" \
  -parse-as-library \
  -module-name Bar \
  -emit-module-path Bar.swiftmodule/x86_64.swiftmodule \
  -emit-objc-header-path Bar.swiftmodule/Bar-Swift.h \
  -I"Foo.swiftmodule" \
  -output-file-map buck-example-output_map.json

$CLANG -g -c buck-example-src/bar.m -o out/bar-m.o \
  -x objective-c \
  -arch x86_64 \
  -std=gnu11 \
  -D_LIBCPP_HAS_NO_STRONG_ENUMS=1 \
  -isysroot "$SWIFT_SDK" \
  -fasm-blocks -fstrict-aliasing \
  -mmacosx-version-min=10.10 \
  -I"Bar.swiftmodule" \
  -I"Foo.swiftmodule" \
  -fobjc-arc -fno-objc-arc-exceptions -Qunused-arguments

$LIBTOOL Bar.swiftmodule/bar.o out/bar-m.o \
  -static \
  -arch_only x86_64 \
  -syslibroot "$SWIFT_SDK" \
  -L"Bar.swiftmodule" \
  -L"$SWIFT_LIB" \
  -o out-static/libBar.a

# Build the main program, without using dSYM.
$CLANG buck-example-src/main.m -fobjc-arc -o out/main Foo.swiftmodule/foo.o Bar.swiftmodule/bar.o \
  -isysroot "$SWIFT_SDK" \
  -I"Foo.swiftmodule" \
  -I"Bar.swiftmodule" \
  -L"$SWIFT_LIB" \
  -Lout-static \
  -lFoo \
  -lBar \
  -Xlinker -rpath -Xlinker "$SWIFT_LIB" \
  -Xlinker -add_ast_path -Xlinker Bar.swiftmodule/x86_64.swiftmodule \
  -Xlinker -add_ast_path -Xlinker Foo.swiftmodule/x86_64.swiftmodule

# Run LLDB commands.
$LLDB out/main -b -s lldb_commands.txt
