//
//  Line2D.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 02/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import GeoCoordinates

public struct Line2D: GeoModels.Line, Hashable {
	
	public typealias CoordinateSystem = GeoModels.Geo2D
	
	public let start: Self.Point
	public let end: Self.Point
	
	public var latitudeDelta: Latitude {
		self.end.latitude - self.start.latitude
	}
	public var longitudeDelta: Longitude {
		self.end.longitude - self.start.longitude
	}
	public var minimalLongitudeDelta: Longitude {
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
