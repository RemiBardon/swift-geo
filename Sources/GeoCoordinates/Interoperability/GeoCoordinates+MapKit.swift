//
//  GeoCoordinates+MapKit.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 02/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

#if canImport(MapKit)
import MapKit

extension Coordinate2D {

	public var mkMapPoint: MKMapPoint {
		MKMapPoint(clLocationCoordinate2D)
	}

}
#endif
