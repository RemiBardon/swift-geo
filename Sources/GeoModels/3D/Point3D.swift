//
//  Point3D.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 06/03/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

public typealias Point3D = Coordinate3D

extension Point3D: Point {}

extension Point3D: CustomDebugStringConvertible {
	
	public var debugDescription: String { "\(String(reflecting: self.twoDimensions)) \(self.altitude)m" }
	
}
