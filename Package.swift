// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "QuickJS-NG-SwiftPM",
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(
      name: "QuickJS-NG-SwiftPM",
      targets: ["QuickJSNG", "QuickJavaScript"]
    )
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "QuickJSNG",
      publicHeadersPath: "Includes"
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
