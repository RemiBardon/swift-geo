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

public protocol LineString<GeometricSystem>:
	GeodeticGeometry.MultiLine,
	CustomStringConvertible,
	CustomDebugStringConvertible
{

	init(points: Points)
	init(coordinates: AtLeast2<[Self.Point.Coordinates]>)

	mutating func append(_ point: Point)

}

public extension LineString {

	init(coordinates: AtLeast2<[Self.Point.Coordinates]>) {
		let points1: NonEmpty<[Self.Point]> = coordinates.map(Self.Point.init(coordinates:))
		let points2 = try! Self.Points.init(from: points1)
		self.init(points: points2)
	}

}

extension LineString {

	public func closed() -> Self {
		var copy = self
		copy.close()
		return copy
	}

	public mutating func close() {
		let firstPoint = self.points.first
		if self.points.last != firstPoint {
			self.append(firstPoint)
		}
	}

}

extension LineString {

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

extension LineString where Self.Lines.RawValue: RangeReplaceableCollection {

	public var lines: Self.Lines {
		let lines = self.points.adjacentPairs().map(Self.Line.init(start:end:))
		return try! Self.Lines(from: lines)
	}
	
	public init(points: Points) {
		let lines = points.adjacentPairs().map(Self.Line.init(start:end:))
		self.init(lines: try! Self.Lines(from: lines))
	}

}

extension LineString where Self.Lines.RawValue: BidirectionalCollection {

	public init(lines: Lines) {
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
