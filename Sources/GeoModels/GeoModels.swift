//
//  GeoModels.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 02/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

// TODO: Create custom struct that handles cycling in an interval
public typealias Coordinate = Double

public struct Coordinate2D: Hashable {
	
	public static var zero: Coordinate2D {
		Coordinate2D(latitude: 0, longitude: 0)
	}
	
	public var latitude: Coordinate
	public var longitude: Coordinate
	
	public var x: Coordinate { longitude }
	public var y: Coordinate { latitude }
	
	public var withPositiveLongitude: Coordinate2D {
		if longitude < 0 {
			// `longitude` is negative, so we end up with `360 - |longitude|`
			return self.offsetBy(dLong: 360)
		} else {
			return self
		}
	}
	
	public init(
		latitude: Coordinate,
		longitude: Coordinate
	) {
		self.latitude = latitude
		self.longitude = longitude
	}
	
	public func offsetBy(dLat: Coordinate = 0, dLong: Coordinate = 0) -> Coordinate2D {
		Coordinate2D(latitude: latitude + dLat, longitude: longitude + dLong)
	}
	public func offsetBy(dx: Coordinate = 0, dy: Coordinate = 0) -> Coordinate2D {
		Coordinate2D(latitude: latitude + dy, longitude: longitude + dx)
	}
	
}

public struct Line2D: Hashable {
	
	public let start: Coordinate2D
	public let end: Coordinate2D
	
	public var latitudeDelta: Coordinate {
		end.latitude - start.latitude
	}
	public var longitudeDelta: Coordinate {
		end.longitude - start.longitude
	}
	public var minimalLongitudeDelta: Coordinate {
		let delta = longitudeDelta
		if delta > 180 {
			return delta - 360
		} else if delta <= -180 {
			return delta + 360
		} else {
			return delta
		}
	}
	
	public var crosses180thMeridian: Bool {
		abs(longitudeDelta) > 180
	}
	
	public init(start: Coordinate2D, end: Coordinate2D) {
		self.start = start
		self.end = end
	}
	
}

public struct BoundingBox2D: Hashable {
	
	public var southWest: Coordinate2D
	public var width: Coordinate
	public var height: Coordinate
	
	public var southLatitude: Coordinate {
		southWest.latitude
	}
	public var northLatitude: Coordinate {
		southLatitude + height
	}
	public var centerLatitude: Coordinate {
		southLatitude + (height / 2.0)
	}
	public var westLongitude: Coordinate {
		southWest.longitude
	}
	public var eastLongitude: Coordinate {
		let longitude = westLongitude + width
		if longitude > 180 {
			return longitude - 360
		} else {
			return longitude
		}
	}
	public var centerLongitude: Coordinate {
		let longitude = westLongitude + (width / 2.0)
		if longitude > 180 {
			return longitude - 360
		} else {
			return longitude
		}
	}
	
	public var northEast: Coordinate2D {
		Coordinate2D(latitude: northLatitude, longitude: eastLongitude)
	}
	public var northWest: Coordinate2D {
		Coordinate2D(latitude: northLatitude, longitude: westLongitude)
	}
	public var southEast: Coordinate2D {
		Coordinate2D(latitude: southLatitude, longitude: westLongitude)
	}
	public var center: Coordinate2D {
		Coordinate2D(latitude: centerLatitude, longitude: centerLongitude)
	}
	
	public var south: Coordinate2D {
		southAtLongitude(centerLongitude)
	}
	public var north: Coordinate2D {
		northAtLongitude(centerLongitude)
	}
	public var west: Coordinate2D {
		westAtLatitude(centerLatitude)
	}
	public var east: Coordinate2D {
		eastAtLatitude(centerLatitude)
	}
	
	public var crosses180thMeridian: Bool {
		westLongitude > eastLongitude
	}
	
	public init(
		southWest: Coordinate2D,
		width: Coordinate,
		height: Coordinate
	) {
		self.southWest = southWest
		self.width = width
		self.height = height
	}
	
	public init(
		southWest: Coordinate2D,
		northEast: Coordinate2D
	) {
		self.init(
			southWest: southWest,
			width: northEast.longitude - southWest.longitude,
			height: northEast.latitude - southWest.latitude
		)
	}
	
	public func southAtLongitude(_ longitude: Coordinate) -> Coordinate2D {
		Coordinate2D(latitude: northEast.latitude, longitude: longitude)
	}
	public func northAtLongitude(_ longitude: Coordinate) -> Coordinate2D {
		Coordinate2D(latitude: southWest.latitude, longitude: longitude)
	}
	public func westAtLatitude(_ latitude: Coordinate) -> Coordinate2D {
		Coordinate2D(latitude: latitude, longitude: southWest.longitude)
	}
	public func eastAtLatitude(_ latitude: Coordinate) -> Coordinate2D {
		Coordinate2D(latitude: latitude, longitude: northEast.longitude)
	}
	
	public func offsetBy(dLat: Coordinate = 0, dLong: Coordinate = 0) -> BoundingBox2D {
		BoundingBox2D(
			southWest: southWest.offsetBy(dLat: dLat, dLong: dLong),
			northEast: northEast.offsetBy(dLat: dLat, dLong: dLong)
		)
	}
	public func offsetBy(dx: Coordinate = 0, dy: Coordinate = 0) -> BoundingBox2D {
		BoundingBox2D(
			southWest: southWest.offsetBy(dx: dx, dy: dy),
			northEast: northEast.offsetBy(dx: dx, dy: dy)
		)
	}
	
}
