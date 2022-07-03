// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "swift-geo",
	products: [
		// Products define the executables and libraries a package produces, and make them visible to other packages.
		.library(name: "GeoCoordinates", targets: ["GeoCoordinates"]),
		.library(name: "GeoModels", targets: ["GeoModels"]),
		.library(name: "Turf", targets: ["Turf"]),
	],
	dependencies: [
		.package(url: "https://github.com/apple/swift-algorithms", .upToNextMajor(from: "1.0.0")),
		.package(
			url: "https://github.com/RemiBardon/swift-nonempty",
			// Last commit to date on https://github.com/RemiBardon/swift-nonempty/compare/nested-nonempty.
			revision: "d6058befda633b3d9d44b0c99fac52bb7fedd01f"
		),
	],
	targets: [
		// Targets are the basic building blocks of a package. A target can define a module or a test suite.
		// Targets can depend on other targets in this package, and on products in packages this package depends on.
		.target(name: "GeoCoordinates"),
		.testTarget(name: "GeoCoordinatesTests", dependencies: [
			"GeoCoordinates",
			.product(name: "Algorithms", package: "swift-algorithms"),
		]),
		.target(
			name: "GeoModels",
			dependencies: [
				"GeoCoordinates",
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
//				.unsafeFlags([
//					"-Xfrontend", "-requirement-machine-protocol-signatures=on",
//					"-Xfrontend", "-requirement-machine-inferred-signatures=on",
//					"-Xfrontend", "-requirement-machine-abstract-signatures=on",
//				]),
			]
		),
		.testTarget(name: "GeoModelsTests", dependencies: ["GeoModels"]),
		.target(
			name: "Turf",
			dependencies: [
				.target(name: "GeoModels"),
				.product(name: "Algorithms", package: "swift-algorithms"),
			],
			swiftSettings: [
				// Debug compile times
//				.unsafeFlags([
//					"-Xfrontend", "-debug-time-function-bodies",
//					"-Xfrontend", "-debug-time-expression-type-checking",
//				]),
				// Fix compiler issue. For more details, see
				// <https://forums.swift.org/t/wrong-redundant-conformance-constraint-warning/56207>.
//				.unsafeFlags([
//					"-Xfrontend", "-requirement-machine-protocol-signatures=on",
//					"-Xfrontend", "-requirement-machine-inferred-signatures=on",
//					"-Xfrontend", "-requirement-machine-abstract-signatures=on",
//				]),
			]
		),
		.testTarget(
			name: "TurfTests",
			dependencies: ["Turf"]
		),
	]
)
