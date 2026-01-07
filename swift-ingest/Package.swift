// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "swift-ingest",
    platforms: [.macOS(.v12)],
    products: [
        .executable(name: "swift-ingest", targets: ["swift-ingest"]),
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "swift-ingest",
            path: "Sources/swift-ingest"
        ),
        // No test target included in the container build; keep package simple.
    ]
)
