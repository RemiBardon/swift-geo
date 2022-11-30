//
//  WGS84+Conversions.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 30/11/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import GeodeticConversions
import WGS84Core

extension EPSG4978: ConvertibleCRS {
	public static func toEPSG4978(_ coordinates: Self.Coordinates) -> Self.Coordinates {
		coordinates
	}
	public static func fromEPSG4978(_ coordinates: Self.Coordinates) -> Self.Coordinates {
		coordinates
	}
}

extension EPSG4326: ConvertibleCRS {
	public static func toEPSG4978(_ coordinates: Self.Coordinates) -> Coordinates3DOf<EPSG4978> {
		coordinates.to3D(EPSG4979.self).to(EPSG4978.self)
	}
	public static func fromEPSG4978(_ coordinates: Coordinates3DOf<EPSG4978>) -> Self.Coordinates {
		coordinates.to(EPSG4979.self).to2D(Self.self)
	}
}

extension EPSG4979: ConvertibleCRS {
	public static func toEPSG4978(_ coordinates: Self.Coordinates) -> Coordinates3DOf<EPSG4978> {
		coordinates.toGeocentric(EPSG4978.self)
	}
	public static func fromEPSG4978(_ coordinates: Coordinates3DOf<EPSG4978>) -> Self.Coordinates {
		coordinates.toGeographic(Self.self)
	}
}
