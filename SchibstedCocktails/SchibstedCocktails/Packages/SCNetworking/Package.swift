// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SCNetworking",
    platforms: [.iOS(.v18)],
    products: [
        .library(name: "SCNetworking", targets: ["SCNetworking"]),
        .library(name: "SCNetworkingProtocols", targets: ["SCNetworkingProtocols"]),
    ],
    dependencies: [
        .package(path: "../SCCommon")
    ],
    targets: [
        .target(
            name: "SCNetworking",
            dependencies: [
                "SCNetworkingProtocols",
                "SCCommon"
            ],
            path: "Sources/SCNetworking"
        ),
        .target(
            name: "SCNetworkingProtocols",
            dependencies: [],
            path: "Sources/SCNetworkingProtocols"
        ),
        .testTarget(
            name: "SCNetworkingTests",
            dependencies: ["SCNetworking", "SCNetworkingProtocols"]
        )
    ]
)
