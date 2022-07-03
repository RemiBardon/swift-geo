//
//  Line3D.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 08/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import GeoCoordinates

public struct Line3D: GeoModels.Line, Hashable {
	
	public typealias CoordinateSystem = Geo3D
	public typealias Point = Point3D
	
	public let start: Point
	public let end: Point
	
	public var altitudeDelta: Altitude {
		end.altitude - start.altitude
	}
	
	public init(start: Point, end: Point) {
		self.start = start
		self.end = end
	}
	
}

extension Line3D: GeoCoordinates.CompoundDimension {
	
	public typealias LowerDimension = GeoModels.Line2D
	
	public var lowerDimension: LowerDimension {
		Self.LowerDimension(start: self.start.lowerDimension, end: self.end.lowerDimension)
	}
	
}
