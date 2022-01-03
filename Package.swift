// swift-tools-version:5.3

import PackageDescription

let package = Package(
  name: "FZImageCache",
  platforms: [
    .macOS(.v10_15), .iOS(.v14), .tvOS(.v14)
  ],
  products: [
    .library(
      name: "FZImageCache",
      targets: ["FZImageCache"]),
  ],
  targets: [
    .binaryTarget(
      name: "FZImageCache",
      sources: ["FZImageCache/FZImageCache.h"],
      path: "./FZImageCache.xcframework")
  ]
)
