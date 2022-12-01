//
//  LinearRing.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 17/03/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import Algorithms
import Geodesy
import NonEmpty

// MARK: - Protocol

public protocol LinearRingProtocol<CRS>: GeodeticGeometry.LineStringProtocol
//where Lines.Collection: RangeReplaceableCollection
{}

// MARK: - Implementation

public struct LinearRing<CRS>: GeodeticGeometry.LinearRingProtocol
//where Lines.Collection: RangeReplaceableCollection
where CRS: CoordinateReferenceSystem
{
	public typealias Point = Self.Line.Point
	public typealias Points = AtLeast2<[Self.Line.Point]>
	public typealias Line = GeodeticGeometry.Line<CRS>
	public typealias Lines = NonEmpty<[Self.Line]>

	public var points: Self.Points
	public var lines: Self.Lines {
		get {
			var pairs: [(Self.Point, Self.Point)] = Array(self.points.adjacentPairs())
			if self.points.last != self.points.first {
				pairs.append((self.points.last, self.points.first))
			}
			let lines = pairs.map(Self.Line.init(start:end:))
			return try! Self.Lines(from: lines)
		}
		set { self.points = Self.init(lines: newValue).points }
	}

	public init(points: Self.Points) {
		if points.last == points.first {
			let first = points.first
			// NOTE: `.reversed()` can be called safely without impacting performance,
			//       as it returns a view on the elements (lazy)
			let newPoints = points.reversed().drop(while: { p in p == first }).reversed()
			do {
				self.points = try Self.Points(Array(newPoints))
			} catch {
				logger.error("""
				`LinearRing` initializer was passed too few elements. \
				When removing the first point from the end, the list became too small. \
				Falling back to the full list with a duplicate point.
				""")
				self.points = points
			}
		} else {
			self.points = points
		}
	}

	public mutating func append(_ point: Point) {
		self.points.append(point)
	}
}
