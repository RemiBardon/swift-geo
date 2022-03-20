//
//  Point3D.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 06/03/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

public typealias Point3D = Coordinate3D

extension Point3D: GeoModels.Point {
	
	public typealias CoordinateSystem = Geo3D
	public typealias Components = (X, Y, Z)
	
	public var components: Components { (x, y, z) }
	
	public init(_ components: Components) {
		self.init(x: components.0, y: components.1, z: components.2)
	}
	
}

extension Point3D: CustomDebugStringConvertible {
	
	public var debugDescription: String { "\(String(reflecting: self.twoDimensions)) \(self.altitude)m" }
	
}
