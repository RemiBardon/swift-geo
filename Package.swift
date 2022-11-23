// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

#warning("TODO: Remove Turf dependency from WGS84")
let package = Package(
	name: "swift-geo",
	platforms: [
		.macOS(.v10_15)
	],
	products: [
		// Products define the executables and libraries a package produces, and make them visible to other packages.
		.library(name: "Geodesy", targets: ["Geodesy"]),
		.library(name: "WGS84", targets: ["WGS84"]),
		.library(name: "GeodeticGeometry", targets: ["GeodeticGeometry"]),
		.library(name: "Turf", targets: ["Turf"]),
	],
	dependencies: [
		.package(url: "https://github.com/apple/swift-algorithms", .upToNextMajor(from: "1.0.0")),
		.package(
			url: "https://github.com/RemiBardon/swift-nonempty",
			// Last commit to date on https://github.com/RemiBardon/swift-nonempty/compare/nested-nonempty
			revision: "f951b7bcd4f13586307f53b0de5d1b20976aceab"
		),
		.package(
			url: "https://github.com/pointfreeco/swift-snapshot-testing",
			.upToNextMajor(from: "1.9.0")
		),
	],
	targets: [
		// Targets are the basic building blocks of a package. A target can define a module or a test suite.
		// Targets can depend on other targets in this package, and on products in packages this package depends on.
		.target(name: "SwiftGeoToolbox"),
		.target(name: "ValueWithUnit", dependencies: ["SwiftGeoToolbox"]),
		.target(name: "Geodesy", dependencies: [
			"ValueWithUnit",
			"SwiftGeoToolbox",
		]),
		.target(name: "WGS84Core", dependencies: ["Geodesy"]),
		.testTarget(name: "GeodesyTests", dependencies: ["Geodesy", "WGS84Core"]),
		.target(name: "GeodeticDisplay", dependencies: ["Geodesy"]),
		.testTarget(name: "GeodeticDisplayTests", dependencies: ["GeodeticDisplay", "WGS84"]),
		.target(
			name: "GeodeticGeometry",
			dependencies: [
				"Geodesy",
				"GeodeticDisplay",
				"SwiftGeoToolbox",
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
		.testTarget(name: "GeodeticGeometryTests", dependencies: ["GeodeticGeometry", "WGS84"]),
		.target(name: "WGS84", dependencies: ["GeodeticGeometry", "Turf", "WGS84Core"]),
		.testTarget(name: "WGS84Tests", dependencies: ["WGS84"]),
		.target(
			name: "Turf",
			dependencies: [
				.target(name: "GeodeticGeometry"),
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
			dependencies: [
				"Turf",
				"WGS84",
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
			],
			resources: [.copy("__Snapshots__")]
		),
		.target(name: "TurfMapKit", dependencies: ["Turf", "WGS84"]),
	]
)
