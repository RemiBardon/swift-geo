// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "swift-geo",
	platforms: [
		// TODO: Support `.macOS(.v10_15)` again by using a backwards compatile logging system
		.macOS(.v11),
	],
	products: [
		// Products define the executables and libraries a package produces,
		// and make them visible to other packages.
		.library(name: "Geodesy", targets: ["Geodesy"]),
		.library(name: "GeodeticConversions", targets: ["GeodeticConversions"]),
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
		// Targets are the basic building blocks of a package.
		// A target can define a module or a test suite.
		// Targets can depend on other targets in this package,
		// and on products in packages this package depends on.

		// 🧰 A toolbox with a few shared protocols, shared by most targets
		.target(name: "SwiftGeoToolbox"),

		// 📏 Values with units (angles, lengths…)
		.target(name: "ValueWithUnit", dependencies: ["SwiftGeoToolbox"]),

		// 🌍 Definition of types representing geodesy concepts
		.target(name: "Geodesy", dependencies: [
			"ValueWithUnit",
			"SwiftGeoToolbox",
		]),
		.testTarget(name: "GeodesyTests", dependencies: ["Geodesy", "WGS84Core"]),

		// 📽️ Representing values in different ways
		.target(name: "GeodeticDisplay", dependencies: ["Geodesy"]),
		.testTarget(name: "GeodeticDisplayTests", dependencies: ["GeodeticDisplay", "WGS84Core"]),

		// 📐 Geometric systems on geodetic types
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
		.testTarget(name: "GeodeticGeometryTests", dependencies: ["GeodeticGeometry", "WGS84Geometry"]),

		// 📐 Geometry on geodetic types
		.target(name: "Turf", dependencies: ["TurfCore", "TurfMapKit"]),
		.target(
			name: "TurfCore",
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
			name: "TurfCoreTests",
			dependencies: [
				"Turf",
				"WGS84Turf", // Unfortunately, this depends on `Turf`
				.product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
			],
			resources: [.copy("__Snapshots__")]
		),
		.target(name: "TurfMapKit", dependencies: ["TurfCore", "WGS84Geometry"]),

		// 🗺️ World Geodetic System standard
		.target(name: "WGS84", dependencies: [
			"WGS84Core",
			"WGS84Conversions",
			"WGS84Geometry",
			"WGS84Turf",
		]),
		.testTarget(name: "WGS84Tests", dependencies: ["WGS84"]),
		.target(name: "WGS84Core", dependencies: ["Geodesy", "GeodeticDisplay"]),
		.target(name: "WGS84Conversions", dependencies: ["WGS84Core", "GeodeticConversions"]),
		.target(name: "WGS84Geometry", dependencies: ["WGS84Core", "GeodeticGeometry"]),
		.target(name: "WGS84Turf", dependencies: ["WGS84Geometry", "Turf"]),

		// 🎭 Conversions from one Coordinate Reference System to another
		.target(name: "GeodeticConversions", dependencies: [
			"Geodesy",
			"GeodeticGeometry",
			"WGS84Core",
		]),
		.testTarget(name: "GeodeticConversionsTests", dependencies: [
			"GeodeticConversions",
			"WGS84Conversions",
		]),
	]
)
