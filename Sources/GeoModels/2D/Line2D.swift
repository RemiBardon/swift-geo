//
//  Line2D.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 02/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

public struct Line2D: Line, Hashable {
	
	public typealias Point = Point2D
	
	public let start: Point
	public let end: Point
	
	public var latitudeDelta: Latitude {
		end.latitude - start.latitude
	}
	public var longitudeDelta: Longitude {
		end.longitude - start.longitude
	}
	public var minimalLongitudeDelta: Longitude {
		let delta = longitudeDelta
		
		if delta > .halfRotation {
			return delta - .fullRotation
		} else if delta <= -.halfRotation {
			return delta + .fullRotation
		} else {
			return delta
		}
	}
	
	public var crosses180thMeridian: Bool {
		abs(longitudeDelta) > .fullRotation
	}
	
	public init(start: Point, end: Point) {
		self.start = start
		self.end = end
	}
	
}
