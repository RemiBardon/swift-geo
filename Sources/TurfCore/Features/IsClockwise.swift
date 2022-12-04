//
//  IsClockwise.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 26/03/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import Geodesy
import GeodeticGeometry
import SwiftGeoToolbox

/// Calculates if a given polygon is clockwise or counter-clockwise.
///
/// ```swift
/// let clockwiseRing = LineString2D(Point2D(0, 0), Point2D(1, 1), Point2D(1, 0), Point2D(0, 0))
/// let counterClockwiseRing = LineString2D(Point2D(0, 0), Point2D(1, 0), Point2D(1, 1), Point2D(0, 0))
///
/// isClockwise(clockwiseRing) // true
/// isClockwise(counterClockwiseRing) // false
/// ```
///
/// Ported from [Turf](https://github.com/Turfjs/turf/blob/d72985ce1a577b42340fed5fc70efe8e4bc8b062/packages/turf-boolean-clockwise/index.ts#L19-L35).
public func isClockwise<CRS, Points: Collection>(
	forCollection points: Points
) -> Bool
where CRS: TwoDimensionalCRS,
			Points.Element == Point<CRS>,
			CRS.Coordinates.X: AngularCoordinateComponent,
			CRS.Coordinates.Y: AngularCoordinateComponent
{
	return TurfCore.plannarArea(forCollection: points).sign == .plus
}
