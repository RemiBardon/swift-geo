//
//  LineString.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 14/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import Algorithms
import GeodeticDisplay
import NonEmpty

// MARK: - Protocol

public protocol LineStringProtocol<CRS>: GeodeticGeometry.MultiLineProtocol {
	mutating func append(_ point: Self.Point)
}

public extension LineStringProtocol where Self.Lines.RawValue: BidirectionalCollection {
	init(lines: Lines) {
		// If there is only one line, `adjacentPairs` will return `[]`, so `points` will be empty
		var points: [Point] = lines.adjacentPairs().map { line1, line2 in
			precondition(line2.start == line1.end, "\(line2) is not attached to \(line1).")
			return line2.start
		}
		// For the reason explained above, those points cannot be in the array already
		points.insert(lines.first.start, at: 0)
		points.append(lines.last.end)
		// We are safe here, as we know for sure we have at least two elements
		self.init(points: try! AtLeast2(points))
	}
}

// MARK: - Implementation

public struct LineString<CRS>: LineStringProtocol
where CRS: CoordinateReferenceSystem {
	public typealias Point = Self.Line.Point
	public typealias Points = AtLeast2<[Self.Line.Point]>
	public typealias Line = GeodeticGeometry.Line<CRS>
	public typealias Lines = NonEmpty<[Self.Line]>

	public var points: Self.Points
	public var lines: Self.Lines {
		get {
			let pairs = self.points.adjacentPairs()
			let lines = pairs.map(Self.Line.init(start:end:))
			return try! Self.Lines(from: lines)
		}
		set { self.points = Self.init(lines: newValue).points }
	}

	public init(points: Self.Points) {
		self.points = points
	}

	public mutating func append(_ point: Point) {
		self.points.append(point)
	}
}

public extension LineString {
	init(coordinates: AtLeast2<[Self.Point.Coordinates]>) {
		let points: [Self.Point] = coordinates.map(Self.Point.init(coordinates:))
		self.init(points: try! Self.Points(points))
	}
}

public extension LineString {
	mutating func close() {
		let firstPoint = self.points.first
		if self.points.last != firstPoint {
			self.append(firstPoint)
		}
	}
	func closed() -> Self {
		var copy = self
		copy.close()
		return copy
	}
	func ring() -> LinearRing<CRS> { .init(points: self.points) }
}

extension LineString: CustomStringConvertible, CustomDebugStringConvertible {
	public var description: String {
		let descriptions: [String] = self.points.map { p in
			String(describing: p.coordinates)
		}
		return "[\(descriptions.joined(separator: ", "))]"
	}
	public var debugDescription: String {
		let descriptions: [String] = self.points.map { p in
			String(reflecting: p.coordinates.components)
		}
		return "<LineString | \(CRS.epsgName)>[\(descriptions.joined(separator: ","))]"
	}
}

extension LineString: Iterable {
	public typealias Element = Self.Line
	public func makeIterator() -> NonEmptyIterator<Self.Lines> {
		NonEmptyIterator(base: self.lines)
	}
}
