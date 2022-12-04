//
//  CenterOfMass.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 26/03/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import Geodesy
import GeodeticGeometry
import SwiftGeoToolbox

// MARK: - Functions

/// Returns the [center of mass](https://en.wikipedia.org/wiki/Center_of_mass) of a polygon.
///
/// Ported from <https://github.com/Turfjs/turf/blob/84110709afda447a686ccdf55724af6ca755c1f8/packages/turf-center-of-mass/index.ts#L32-L86>
///
/// - Note: This code is not very clean, but Compile Time Optimizations have been added to reduce
///         type checking from `>500ms` to `<50ms`.
public func centerOfMass<CRS, Points: Collection>(
	forCollection points: Points
) -> CRS.Coordinates?
where CRS: TwoDimensionalCRS,
			Points.Element == Point<CRS>,
			CRS.Coordinates.X: AngularCoordinateComponent,
			CRS.Coordinates.Y: AngularCoordinateComponent
{
	// First, we neutralize the feature (set it around coordinates [0,0]) to prevent rounding errors
	// We take any point to translate all the points around 0
	guard let centre = TurfCore.centroid(forCollection: points.map(\.coordinates)) else { return nil }
	let translation = centre
	var sx: CRS.Coordinates.X = 0
	var sy: CRS.Coordinates.Y = 0
	var sArea: Double = 0

	let neutralizedPoints: [CRS.Coordinates] = points.map { $0.coordinates - translation }

	for i in 0..<points.count - 1 {
		// pi is the current point
		let pi: CRS.Coordinates = neutralizedPoints[i]
		let xi: CRS.Coordinates.X = pi.x
		let yi: CRS.Coordinates.Y = pi.y

		// pj is the next point (pi+1)
		let pj: CRS.Coordinates = neutralizedPoints[i + 1]
		let xj: CRS.Coordinates.X = pj.x
		let yj: CRS.Coordinates.Y = pj.y

		// a is the common factor to compute the signed area and the final coordinates
		let a: Double = xi.decimalDegrees * yj.decimalDegrees - xj.decimalDegrees * yi.decimalDegrees

		// sArea is the sum used to compute the signed area
		sArea += a

		// sx and sy are the sums used to compute the final coordinates
		let __sx1 = (xi + xj)
		let __sx2 = __sx1 * CRS.Coordinates.X(decimalDegrees: a)
		sx += __sx2
		let __sy1 = (yi + yj)
		let __sy2 = __sy1 * CRS.Coordinates.Y(decimalDegrees: a)
		sy += __sy2
	}

	// Shape has no area: fallback on turf.centroid
	if (sArea == 0) {
		return centre
	} else {
		// Compute the signed area, and factorize 1/6A
		let area: Double = sArea * 0.5
		let areaFactor: Double = 1 / (6 * area)

		// Compute the final coordinates, adding back the values that have been neutralized
		let dx = CRS.Coordinates.X(decimalDegrees: areaFactor) * sx
		let dy = CRS.Coordinates.Y(decimalDegrees: areaFactor) * sy
		return translation + Vector(dx: dx, dy: dy)
	}
}
