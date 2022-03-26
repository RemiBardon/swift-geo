//
//  Line2D.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 02/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

public struct Line2D: GeoModels.Line, Hashable {
	
	public typealias CoordinateSystem = GeoModels.Geo2D
	
	public let start: Self.Point
	public let end: Self.Point
	
	public var latitudeDelta: GeoModels.Latitude {
		self.end.latitude - self.start.latitude
	}
	public var longitudeDelta: GeoModels.Longitude {
		self.end.longitude - self.start.longitude
	}
	public var minimalLongitudeDelta: GeoModels.Longitude {
		let delta = self.longitudeDelta
		
		if delta > .halfRotation {
			return delta - .fullRotation
		} else if delta <= -.halfRotation {
			return delta + .fullRotation
		} else {
			return delta
		}
	}
	
	public var crosses180thMeridian: Bool {
		abs(self.longitudeDelta) > .fullRotation
	}
	
	public init(start: Self.Point, end: Self.Point) {
		self.start = start
		self.end = end
	}
	
}
