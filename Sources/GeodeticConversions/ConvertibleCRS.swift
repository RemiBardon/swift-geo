//
//  ConvertibleCRS.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 30/11/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import Geodesy
import GeodeticGeometry
import WGS84Core

public protocol ConvertibleCRS: CoordinateReferenceSystem {
	static func toEPSG4978(_ coordinates: Self.Coordinates) -> Coordinates3DOf<EPSG4978>
	static func fromEPSG4978(_ coordinates: Coordinates3DOf<EPSG4978>) -> Self.Coordinates
}

public extension Coordinates where CRS: ConvertibleCRS {
	/// Converts a coordinate to the WGS 84 geocentric CRS.
	func toEPSG4978() -> Coordinates3DOf<EPSG4978> {
		Self.CRS.toEPSG4978(self as! Self.CRS.Coordinates)
	}
	/// Converts a coordinate from a CRS to another.
	func to<NewCRS>(_: NewCRS.Type) -> NewCRS.Coordinates where NewCRS: ConvertibleCRS {
		NewCRS.Coordinates.fromEPSG4978(self.toEPSG4978())
	}

	/// Converts a coordinate from the WGS 84 geocentric CRS.
	static func fromEPSG4978(_ coordinates: Coordinates3DOf<EPSG4978>) -> Self {
		Self.CRS.fromEPSG4978(coordinates) as! Self
	}
}

public extension Coordinates3DOf<EPSG4978> {
	/// Converts a 3D coordinate from the WGS 84 geocentric CRS.
	func fromEPSG4978<NewCRS, C: Coordinates<NewCRS>>() -> C where NewCRS: ConvertibleCRS {
		NewCRS.fromEPSG4978(self) as! C
	}
}

public extension Point {
	static func + <OtherCRS>(lhs: Self, rhs: Point<OtherCRS>) -> Self
	where CRS: ConvertibleCRS, OtherCRS: ConvertibleCRS
	{
		Self.init(coordinates: lhs.coordinates + rhs.coordinates.to(to: OtherCRS.self))
	}
}

public extension Vector {
	init<OtherCRS>(from: Point<CRS>, to: Point<OtherCRS>)
	where CRS: ConvertibleCRS, OtherCRS: ConvertibleCRS {
		self.init(rawValue: to.coordinates.to(CRS.self) - from.coordinates)
	}
}
