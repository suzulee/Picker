// swift-tools-version:5.1
//
//  Package.swift
//  Picker
//
//  Created by Richard Zheng on 6/1/20.
//  Copyright © 2020 Richard Zheng. All rights reserved.
//

import PackageDescription

let package = Package(
    name: "name",
    products: [
        .library(name: "App", targets: ["App"]),
        .executable(name: "Run", targets: ["Run"])
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", .upToNextMajor(from: "2.1.0")),
        .package(url: "https://github.com/vapor/fluent-provider.git", .upToNextMajor(from: "1.2.0")),
    ],
    targets: [
        .target(name: "App", dependencies: ["Vapor", "FluentProvider"],
                exclude: [
                    "Config",
                    "Public",
                    "Resources",
                ]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App", "Testing"])
    ]
)
