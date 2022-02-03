//
//  GeoModels+Operators.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 02/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

extension Coordinate2D {
	
	public static func + (lhs: Coordinate2D, rhs: Coordinate2D) -> Coordinate2D {
		return lhs.offsetBy(dLat: rhs.latitude, dLong: rhs.longitude)
	}
	
	public static func - (lhs: Coordinate2D, rhs: Coordinate2D) -> Coordinate2D {
		return lhs + (-rhs)
	}
	
	public prefix static func - (value: Coordinate2D) -> Coordinate2D {
		return Coordinate2D(latitude: -value.latitude, longitude: -value.longitude)
	}
	
}
