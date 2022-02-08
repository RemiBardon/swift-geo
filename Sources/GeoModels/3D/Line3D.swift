//
//  Line3D.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 08/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

public struct Line3D: Hashable {
	
	public let start: Coordinate3D
	public let end: Coordinate3D
	
	public var latitudeDelta: Latitude {
		twoDimensions.latitudeDelta
	}
	public var longitudeDelta: Longitude {
		twoDimensions.longitudeDelta
	}
	public var minimalLongitudeDelta: Longitude {
		twoDimensions.minimalLongitudeDelta
	}
	public var altitudeDelta: Altitude {
		end.altitude - start.altitude
	}
	
	public var crosses180thMeridian: Bool {
		twoDimensions.crosses180thMeridian
	}
	
	public var twoDimensions: Line2D {
		Line2D(start: start.twoDimensions, end: end.twoDimensions)
	}
	
	public init(start: Coordinate3D, end: Coordinate3D) {
		self.start = start
		self.end = end
	}
	
}
