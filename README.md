# SR-2660

This is the sample project created by Todd Fiala in
https://bugs.swift.org/browse/SR-2660, updated to work with modern Swift 4.

To use this yourself, modify `build.sh` and/or `build-driver.sh` such that
`SWIFTC`, `SWIFT_SDK`, `SWIFT_LIB`, `CLANG`, `LLDB` point to appropriate
locations on your host machine, then run `build.sh`. Keep in mind that, if
using an apple/swift and apple/swift-lldb built from source, they will
need to point to revisions that match each other's `.swiftmodule` format.
