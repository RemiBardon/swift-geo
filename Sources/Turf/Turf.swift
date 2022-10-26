//
//  Turf.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 20/04/2021.
//  Copyright © 2021 Rémi Bardon. All rights reserved.
//

import Algorithms
import GeodeticGeometry

// FIXME: Fix formulae so they handle crossing the anti meridian

// MARK: - Bounding box

// MARK: Lines (fix > .halfRotation)

/// Returns the [bounding box](https://en.wikipedia.org/wiki/Minimum_bounding_box) of a polygon.
///
/// - Warning: As stated in [section 3.1.6 of FRC 7946](https://datatracker.ietf.org/doc/html/rfc7946#section-3.1.6),
///   polygon ring MUST follow the right-hand rule for orientation (counterclockwise).
//public func bbox(forPolygon coords: [Point2D]) -> BoundingBox2D? {
//	if coords.adjacentPairs().contains(where: { Line2D(start: $0, end: $1).crosses180thMeridian }) {
//		let offsetCoords = coords.map(\.withPositiveLongitude)
//
//		return Turf.bbox(for: offsetCoords)
//	} else {
//		return Turf.bbox(for: coords)
//	}
//}

/// Returns the [bounding box](https://en.wikipedia.org/wiki/Minimum_bounding_box) enclosing all elements.
//public func bbox<T: Boundable, C: Collection>(for boundables: C) -> T.BoundingBox? where C.Element == T {
//	guard !boundables.isEmpty else { return nil }
//	
//	return boundables.reduce(.zero, { $0.union($1.bbox) })
//}
