//
//  BezierSpline.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 01/09/2022.
//

import Algorithms
import GeoModels
import NonEmpty

fileprivate func pointAlong<Line: GeoModels.Line>(
	line: Line,
	fraction: Double
) -> Line.CoordinateSystem.Point
where Line.CoordinateSystem.Point: Coordinates
{
	precondition((Double(0)...Double(1)).contains(fraction))
	return line.start + ((line.end - line.start) * fraction)
}

fileprivate func pointInQuadCurve<Point: GeoModels.Point>(
	_ p0: Point,
	_ p1: Point,
	_ p2: Point,
	fraction: Double
) -> Point
where Point: Coordinates
{
	typealias Line = Point.CoordinateSystem.Line
	let a: Point = pointAlong(line: Line(from: p0, to: p1), fraction: fraction)
	let b: Point = pointAlong(line: Line(from: p1, to: p2), fraction: fraction)
	return pointAlong(line: Line(from: a, to: b), fraction: fraction)
}

fileprivate func pointInCubicCurve<Point: GeoModels.Point>(
	_ p0: Point,
	_ p1: Point,
	_ p2: Point,
	_ p3: Point,
	fraction: Double
) -> Point
where Point: Coordinates
{
	typealias Line = Point.CoordinateSystem.Line
	let a: Point = pointInQuadCurve(p0, p1, p2, fraction: fraction)
	let b: Point = pointInQuadCurve(p1, p2, p3, fraction: fraction)
	return pointAlong(line: Line(from: a, to: b), fraction: fraction)
}

struct CubicBezierSpline<Point: GeoModels.Point> where Point.CoordinateSystem: CoordinateSystemAlgebra {

	let controls: [(p0: Point, c0: Point, c1: Point, p1: Point)]

	init<Points>(
		points: AtLeast2<Points>,
		sharpness: Double
	)
	where Points: BidirectionalCollection,
	Points.Element == Point,
	Points.Index == Int,
	Point: Coordinates
	{
		precondition(sharpness >= 0, "Sharpness must be >= 0 (was \(sharpness))")
		precondition(sharpness <= 1, "Sharpness must be <= 1 (was \(sharpness))")

		typealias Line = Point.CoordinateSystem.Line

		let lastLine = Line(from: points[points.count - 2], to: points[points.count - 1])
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
		self.controls = lines.adjacentPairs().map { line, nextLine in
				defer { previousLine = line }

				let previousCenter = previousLine.center
				let center = line.center
				let nextCenter = nextLine.center
				let point: Point = line.start
				let nextPoint: Point = line.end

				let dir1 = Line(from: previousCenter, to: center).vector.center
				let dir2 = Line(from: nextCenter, to: center).vector.center

				let ratio: Double = (1 - sharpness)
				let control1: Point = point + ratio * dir1
				let control2: Point = nextPoint + ratio * dir2

				return (p0: point, c0: control1, c1: control2, p1: nextPoint)
			}
	}

	func curve(resolution: Double) -> AtLeast2<[Point]> {
		precondition(resolution >= 1, "Resolution must be >= 1 (was \(resolution))")

		var points: [Point] = self.controls.flatMap { controls -> [Point] in
			stride(from: 0.0, to: 1.0, by: 1 / resolution).map { fraction -> Point in
				pointInCubicCurve(controls.p0, controls.c0, controls.c1, controls.p1, fraction: fraction)
			}
		}
		points.append(self.controls.last!.p1)
		return try! AtLeast2(points)
	}

}
