//
//  WGS84+Turf.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 20/03/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import SwiftGeoToolbox
import TurfCore
import protocol Turf.GeometricSystemAlgebra
import enum WGS84Geometry.WGS842D
import enum WGS84Geometry.WGS843D

extension WGS842D.BoundingBox: Boundable {}
extension WGS842D.Point: Boundable {}

extension WGS842D: GeometricSystemAlgebra {
	public static func center(forBBox bbox: Self.BoundingBox) -> Self.Coordinates {
		let offset: Self.Size = bbox.size / 2
		return bbox.origin.offsetBy(offset.rawValue)
	}
}

extension WGS843D: GeometricSystemAlgebra {}
