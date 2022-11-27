//
//  BezierSpline.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 01/09/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import Algorithms
import GeodeticGeometry
import NonEmpty
import SwiftGeoToolbox

struct CubicBezierSpline<GeometricSystem: GeometricSystemAlgebra>
{
	typealias Coordinates = GeometricSystem.Coordinates
	typealias Point = GeometricSystem.Point
	typealias Line = GeometricSystem.Line

	let controls: [(p0: Coordinates, c0: Coordinates, c1: Coordinates, p1: Coordinates)]

	init<Points>(
		points: AtLeast2<Points>,
		sharpness: Double
	)
	where Points: BidirectionalCollection,
	Points.Element == Point,
	Points.Index == Int
	{
		precondition(sharpness >= 0, "Sharpness must be >= 0 (was \(sharpness))")
		precondition(sharpness <= 1, "Sharpness must be <= 1 (was \(sharpness))")

		let lastLine = Line.init(from: points[points.count - 2], to: points[points.count - 1])
		let lineAfterEnd: Line
		var previousLine: Line
		do {
			if points.last == points.first {
				// If the points form a ring, take last line
				// NOTE: We don't need to check that `points.count > 1`, as points is `AtLeast2`
				lineAfterEnd = Line(from: points.first, to: points.second)
				previousLine = lastLine
			} else {
				// If the points do not form a ring, create a 0-length line
				lineAfterEnd = Line(from: points.last, to: points.last)
				previousLine = Line(from: points.first, to: points.first)
			}
		}

		var lines = points.adjacentPairs().map(Line.init(from:to:))
		lines.append(lineAfterEnd)
		self.controls = lines.adjacentPairs().map { (line: Line, nextLine: Line) in
			defer { previousLine = line }

			let previousCenter = previousLine.center
			let center = line.center
			let nextCenter = nextLine.center
			let point = line.start.coordinates
			let nextPoint = line.end.coordinates

			let dir1 = Line(from: previousCenter, to: center).vector.center
			let dir2 = Line(from: nextCenter, to: center).vector.center

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
		return p1 + Coordinates(fraction) * (p2 - p1)
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
