// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "QuickJavaScript",
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(
      name: "QuickJavaScript",
      targets: ["QuickJSNG", "QuickJavaScript"]
    )
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "QuickJSNG",
      sources: [
        "cutils.c",
        "cutils.h",
        "dtoa.c",
        "dtoa.h",
        "libregexp.c",
        "libregexp.h",
        "libregexp-opcode.h",
        "libunicode.c",
        "libunicode.h",
        "libunicode-table.h",
        "list.h",
        "quickjs-atom.h",
        "quickjs.c",
        "quickjs-c-atomics.h",
        "quickjs.h",
        "quickjs-opcode.h",
        "builtin-array-fromasync.h",
      ],
      publicHeadersPath: "."
    ),
    .target(
      name: "QuickJavaScript",
      dependencies: ["QuickJSNG"]
    ),
    .testTarget(
      name: "QuickJSNGTests",
      dependencies: ["QuickJSNG"]
    ),
    .testTarget(
      name: "QuickJavaScriptTests",
      dependencies: ["QuickJavaScript"]
    ),
  ]
)
