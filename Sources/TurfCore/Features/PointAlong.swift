//
//  PointAlong.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 26/03/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import Geodesy
import GeodeticGeometry
import SwiftGeoToolbox

// MARK: - Functions

public func pointAlong<CRS>(line: Line<CRS>, fraction: Double) -> CRS.Coordinates
where CRS: CoordinateReferenceSystem {
	precondition((Double(0.0)...Double(1.0)).contains(fraction))
	return line.start.coordinates + fraction * line.vector
}
