// swift-tools-version: 5.7

import PackageDescription

let package = Package(
	name: "swift-geo-benchmarks",
	platforms: [
		.macOS(.v13),
	],
	products: [
		.executable(name: "binary-size-ref-1", targets: ["BinarySizeReference1"]),
		.executable(name: "binary-size-1", targets: ["BinarySizeBenchmark1"]),
	],
	dependencies: [
		.package(name: "swift-geo", path: ".."),
	],
	targets: [
		.executableTarget(name: "BinarySizeReference1"),
		.executableTarget(name: "BinarySizeBenchmark1", dependencies: [
			.product(name: "WGS84", package: "swift-geo"),
		]),
		.testTarget(name: "BinarySizeBenchmarks"),
		.testTarget(name: "PerformanceBenchmarks", dependencies: [
			.product(name: "Turf", package: "swift-geo"),
		]),
	]
)
