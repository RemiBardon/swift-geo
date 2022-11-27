//
//  WSG84Core+MapKit.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 02/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

// `MapKit` depends on `CoreLocation`, no need to check
#if canImport(MapKit)
import MapKit

public extension Coordinate2D {

	var mkMapPoint: MKMapPoint {
		MKMapPoint(self.clLocationCoordinate2D)
	}

}
#endif
