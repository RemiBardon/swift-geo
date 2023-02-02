//
//  BinarySizeBenchmark1.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 10/01/2023.
//

import XCTest

/// 1 kB
let kB: UInt64 = 1_000
/// 1 MB
let MB: UInt64 = 1_000_000

final class BinarySizeBenchmark1: XCTestCase {

	static var refSize: UInt64 = 0

	override class func setUp() {
		let binaryName = "binary-size-ref-1"
		do {
			Self.swiftBuild(binaryName)
			let binary = try FileAttributes(for: Self.binary(binaryName))
			refSize = binary.fileSize
			print("\(binaryName) binary has size \(binary.fileSizeString)")
		} catch {
			print("\(binaryName) binary could not be built: \(String(describing: error))")
		}
	}

	func testBinarySize() throws {
		let binaryName = "binary-size-1"
		Self.swiftBuild(binaryName)
		let binary = try FileAttributes(for: Self.binary(binaryName))
		XCTAssertLessThan(binary.fileSize, 3500 * kB, binary.fileSizeString)
		print("\(binaryName) binary has size \(binary.fileSizeString)")
	}

	// MARK: Helpers

	private static let configuration: String = "release"

	private static let fileURL: URL = URL(string: #file)!
	private static let packageFolder: URL = fileURL
		.deletingLastPathComponent()
		.deletingLastPathComponent()
		.deletingLastPathComponent()
	private static func binary(_ name: String) -> URL {
		return Self.packageFolder.appending(
			components: ".build", Self.configuration, name,
			directoryHint: .notDirectory
		)
	}

	/// - Copyright: <https://stackoverflow.com/a/26973384/10967642>
	@discardableResult
	private static func swift(_ args: [String]) -> Int32 {
		let task = Process()
		task.executableURL = URL(fileURLWithPath: "/usr/bin/swift")
		task.arguments = args
		print("Running `swift \(args.joined(separator: " "))`…")
		try? task.run()
		task.waitUntilExit()
		return task.terminationStatus
	}

	/// - Copyright: <https://stackoverflow.com/a/26973384/10967642>
	@discardableResult
	private static func swift(_ args: String...) -> Int32 {
		return swift(args)
	}

	@discardableResult
	private static func swiftBuild(_ binaryName: String) -> Int32 {
		let args = [
			"build",
			"--package-path", Self.packageFolder.absoluteString,
			"--product", binaryName,
			"-c", Self.configuration,
			"-Xswiftc", "-cross-module-optimization",
			"-Xswiftc", "-Osize",
		]
		return swift(args)
	}

}

/// - Copyright: Inspired by <https://stackoverflow.com/a/48566887/10967642>.
fileprivate struct FileAttributes {
	let fileSize: UInt64
	let fileSizeString: String
	init(for url: URL) throws {
		let attributes = try FileManager.default.attributesOfItem(atPath: url.path)
		self.fileSize = attributes[.size] as? UInt64 ?? UInt64(0)
		self.fileSizeString = ByteCountFormatter.string(fromByteCount: Int64(self.fileSize), countStyle: .file)
	}
}
