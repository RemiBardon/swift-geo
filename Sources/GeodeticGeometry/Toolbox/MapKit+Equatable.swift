//
//  MapKit+Equatable.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 06/01/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

#if canImport(MapKit)
import MapKit

extension MKCoordinateRegion: Equatable {
	
	public static func == (lhs: Self, rhs: Self) -> Bool {
		return lhs.center == rhs.center
		&& lhs.span == rhs.span
	}
	
}

extension MKCoordinateSpan: Equatable {
	
	public static func == (lhs: Self, rhs: Self) -> Bool {
		// Deltas are considered equal if there's less than 1.1112m between them.
		// This equals to 0.00001° along the equator.
		// See <https://wiki.openstreetmap.org/wiki/Precision_of_coordinates> for further explanations.
		let latitudeEqual = lhs.latitudeDelta.distance(to: rhs.latitudeDelta) < 0.000_01
		let longitudeEqual = lhs.longitudeDelta.distance(to: rhs.longitudeDelta) < 0.000_01
		return latitudeEqual && longitudeEqual
	}
	
}

extension MKMapPoint: Equatable {
	
	public static func == (lhs: MKMapPoint, rhs: MKMapPoint) -> Bool {
		return MKMapPointEqualToPoint(lhs, rhs)
	}
	
}

extension MKMapSize: Equatable {
	
	public static func == (lhs: MKMapSize, rhs: MKMapSize) -> Bool {
		return MKMapSizeEqualToSize(lhs, rhs)
	}
	
}

extension MKMapRect: Equatable {
	
	public static func == (lhs: MKMapRect, rhs: MKMapRect) -> Bool {
		return MKMapRectEqualToRect(lhs, rhs)
	}
	
}
#endif
