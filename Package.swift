// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "swift-geo",
	products: [
		// Products define the executables and libraries a package produces, and make them visible to other packages.
		.library(
			name: "GeoModels",
			targets: ["GeoModels"]
		),
	],
	dependencies: [
		.package(url: "https://github.com/apple/swift-algorithms", .upToNextMajor(from: "1.0.0")),
		.package(url: "https://github.com/RemiBardon/swift-nonempty", branch: "nested-nonempty"),
	],
	targets: [
		// Targets are the basic building blocks of a package. A target can define a module or a test suite.
		// Targets can depend on other targets in this package, and on products in packages this package depends on.
		.target(
			name: "GeoModels",
			dependencies: [
				.product(name: "Algorithms", package: "swift-algorithms"),
				.product(name: "NonEmpty", package: "swift-nonempty"),
			],
			swiftSettings: [
				// Debug compile times
//				.unsafeFlags([
//					"-Xfrontend", "-debug-time-function-bodies",
//					"-Xfrontend", "-debug-time-expression-type-checking",
//				]),
				// Fix compiler issue. For more details, see
				// <https://forums.swift.org/t/wrong-redundant-conformance-constraint-warning/56207>.
				.unsafeFlags([
					"-Xfrontend", "-enable-requirement-machine-loop-normalization",
//					"-Xfrontend", "-requirement-machine-protocol-signatures=on",
//					"-Xfrontend", "-requirement-machine-inferred-signatures=on",
				]),
			]
		),
		.testTarget(
			name: "GeoModelsTests",
			dependencies: [
				.target(name: "GeoModels"),
				.product(name: "Algorithms", package: "swift-algorithms"),
			]
		),
		.target(
			name: "Turf",
			dependencies: [
				.target(name: "GeoModels"),
				.product(name: "Algorithms", package: "swift-algorithms"),
			],
			swiftSettings: [
				// Debug compile times
				.unsafeFlags([
					"-Xfrontend", "-debug-time-function-bodies",
					"-Xfrontend", "-debug-time-expression-type-checking",
				]),
				// Fix compiler issue. For more details, see
				// <https://forums.swift.org/t/wrong-redundant-conformance-constraint-warning/56207>.
				.unsafeFlags([
//					"-Xfrontend", "-requirement-machine-protocol-signatures=on",
//					"-Xfrontend", "-requirement-machine-inferred-signatures=on",
				]),
			]
		),
		.testTarget(
			name: "TurfTests",
			dependencies: ["Turf"]
		),
	]
)
