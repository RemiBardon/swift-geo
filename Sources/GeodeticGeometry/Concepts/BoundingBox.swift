//
//  BoundingBox.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 04/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import Geodesy
import SwiftGeoToolbox

public protocol BoundingBox<GeometricSystem>: Hashable, Zeroable {

	typealias CRS = GeometricSystem.CRS
	associatedtype GeometricSystem: GeodeticGeometry.GeometricSystem<CRS>
	typealias Coordinates = GeometricSystem.Coordinates
	typealias Size = GeometricSystem.Size
	
	var origin: Coordinates { get }
	var size: Size { get }
	
	init(origin: Coordinates, size: Size)
	init(min: Coordinates, max: Coordinates)

	#warning("TODO: Reimplement `BoundingBox.union(_ other: Self)`")
	/// The union of bounding boxes gives a new bounding box that encloses the given two.
//	func union(_ other: Self) -> Self
	
}

public extension BoundingBox {
	
	static var zero: Self {
		Self.init(origin: .zero, size: .zero)
	}

	init(min: Coordinates, max: Coordinates) {
		self.init(origin: min, size: Size.init(from: min, to: max))
	}
	
}
