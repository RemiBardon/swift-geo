// swift-tools-version: 5.7

import PackageDescription

let package = Package(
	name: "SwiftGeoBinarySizeBenchmark",
	platforms: [
		.macOS(.v10_15),
	],
	products: [
		.executable(
			name: "SwiftGeoBinarySizeBenchmark1",
			targets: ["SwiftGeoBinarySizeBenchmark1"]
		),
	],
	dependencies: [
		.package(name: "swift-geo", path: "../.."),
	],
	targets: [
		.executableTarget(name: "SwiftGeoBinarySizeBenchmark1", dependencies: [
			.product(name: "WGS84", package: "swift-geo"),
		]),
	]
)
