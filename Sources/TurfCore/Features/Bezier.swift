//
//  Bezier.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 26/03/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import GeodeticGeometry
import NonEmpty

// MARK: - Functions

public func bezier<CRS>(
	forLineString lineString: LineString<CRS>,
	sharpness: Double,
	resolution: Double
) -> LineString<CRS>
where CRS.Coordinates: BoundableCoordinates
{
	let coordinates = try! AtLeast2<[CRS.Coordinates]>(lineString.points.map(\.coordinates))
	let spline = CubicBezierSpline<CRS>(coordinates: coordinates, sharpness: sharpness)
	let points = AtLeast2<[Point<CRS>]>(
		rawValue: spline.curve(resolution: resolution).map(Point<CRS>.init(coordinates:))
	)!
	return LineString<CRS>(points: points)
}

// MARK: - Helpers

// MARK: Shape

public extension LineString where CRS.Coordinates: BoundableCoordinates {
	func bezier(sharpness: Double, resolution: Double) -> Self {
		TurfCore.bezier(
			forLineString: self,
			sharpness: sharpness,
			resolution: resolution
		)
	}
}
