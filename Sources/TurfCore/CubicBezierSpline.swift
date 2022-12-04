//
//  BezierSpline.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 01/09/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import Algorithms
import Geodesy
import GeodeticGeometry
import NonEmpty
import SwiftGeoToolbox

struct CubicBezierSpline<CRS>
where CRS: Geodesy.CoordinateReferenceSystem,
			CRS.Coordinates: BoundableCoordinates
{
	typealias Coordinates = CRS.Coordinates
	typealias Line = GeodeticGeometry.Line<CRS>

	let controls: [(p0: Coordinates, c0: Coordinates, c1: Coordinates, p1: Coordinates)]

	init<C>(coordinates: AtLeast2<C>, sharpness: Double)
	where C: BidirectionalCollection,
				C.Element == Self.Coordinates,
				C.Index == Int
	{
		precondition(sharpness >= 0, "Sharpness must be >= 0 (was \(sharpness))")
		precondition(sharpness <= 1, "Sharpness must be <= 1 (was \(sharpness))")

		let lineAfterEnd: Line
		var previousCenter: Coordinates
		do {
			let firstLine = Line(from: coordinates.first, to: coordinates.second)
			// NOTE: We don't need to check that `coordinates.count > 1`, as coordinates is `AtLeast2`
			let lastLine = Line(
				from: coordinates[coordinates.count - 2],
				to: coordinates[coordinates.count - 1]
			)
			if coordinates.last == coordinates.first {
				// If the coordinates form a ring, take the first line as the line after the last
				// and the last line as the one before the first.
				lineAfterEnd = firstLine
				previousCenter = lastLine.center
			} else {
				// If the coordinates do not form a ring, use first and last lines.
				// This means control directions will equal `Vector.zero`,
				// generating a better bezier interpolation.
				lineAfterEnd = lastLine
				previousCenter = firstLine.center
			}
		}

		var lines = coordinates.adjacentPairs().map(Line.init(from:to:))
		lines.append(lineAfterEnd)
		self.controls = lines.adjacentPairs().map { (line: Line, nextLine: Line) in
			let center = line.center
			defer { previousCenter = center }
			let nextCenter = nextLine.center
			let point = line.start.coordinates
			let nextPoint = line.end.coordinates

			let dir1 = Vector<CRS>(from: previousCenter, to: center).half
			let dir2 = Vector<CRS>(from: nextCenter, to: center).half

			let ratio: Double = (1 - sharpness)
			let control1 = point + ratio * dir1
			let control2 = nextPoint + ratio * dir2

			return (p0: point, c0: control1, c1: control2, p1: nextPoint)
		}
	}

	func curve(resolution: Double) -> AtLeast2<[Coordinates]> {
		precondition(resolution >= 1, "Resolution must be >= 1 (was \(resolution))")

		var points: [Coordinates] = self.controls.flatMap { controls -> [Coordinates] in
			stride(from: 0.0, to: 1.0, by: 1.0 / resolution).map { fraction -> Coordinates in
				Self.pointInCubicCurve(
					controls.p0,
					controls.c0,
					controls.c1,
					controls.p1,
					fraction: fraction
				)
			}
		}
		points.append(self.controls.last!.p1)
		return try! AtLeast2(points)
	}

	static func pointBetween(
		_ p1: Coordinates,
		and p2: Coordinates,
		fraction: Double
	) -> Coordinates {
		precondition((Double(0.0)...Double(1.0)).contains(fraction))
		return p1 + fraction * Vector(from: p1, to: p2)
	}

	static func pointInQuadCurve(
		_ p0: Coordinates,
		_ p1: Coordinates,
		_ p2: Coordinates,
		fraction: Double
	) -> Coordinates {
		let a = pointBetween(p0, and: p1, fraction: fraction)
		let b = pointBetween(p1, and: p2, fraction: fraction)
		return pointBetween(a, and: b, fraction: fraction)
	}

	static func pointInCubicCurve(
		_ p0: Coordinates,
		_ p1: Coordinates,
		_ p2: Coordinates,
		_ p3: Coordinates,
		fraction: Double
	) -> Coordinates {
		let a = pointInQuadCurve(p0, p1, p2, fraction: fraction)
		let b = pointInQuadCurve(p1, p2, p3, fraction: fraction)
		return pointBetween(a, and: b, fraction: fraction)
	}

}
