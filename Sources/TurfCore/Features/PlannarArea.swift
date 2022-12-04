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

/// Calculates the signed area of a planar non-self-intersecting polygon
/// (not taking into account the curvature of the Earth).
///
/// Formula from <https://mathworld.wolfram.com/PolygonArea.html>.
public func plannarArea<CRS, Points: Collection>(
	forCollection points: Points
) -> Double
where CRS: TwoDimensionalCRS,
			Points.Element == Point<CRS>,
			CRS.Coordinates.X: AngularCoordinateComponent,
			CRS.Coordinates.Y: AngularCoordinateComponent
{
	guard let first = points.first else { return 0 }

	var ring = Array(points)
	// Close the ring
	if ring.last != first {
		ring.append(first)
	}

	var area: Double = 0
	for (c1, c2) in ring.adjacentPairs() {
		area += c1.coordinates.x.decimalDegrees * c2.coordinates.y.decimalDegrees
					- c2.coordinates.x.decimalDegrees * c1.coordinates.y.decimalDegrees
	}

	return area / 2.0
}
