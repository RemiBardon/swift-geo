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

public protocol LineString<Point>:
	GeodeticGeometry.MultiLine,
	CustomDebugStringConvertible
{

	init(points: Points)

	mutating func append(_ point: Point)

}

extension LineString {

	public var debugDescription: String { String(reflecting: self) }

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

extension LineString where Self.Point: GeographicNotation {

	public var debugDescription: String {
		let descriptions: [String] = self.points.map { "\(String(reflecting: $0))" }
		return "[\(descriptions.joined(separator: ","))]"
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
