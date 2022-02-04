//
//  BoundingBox2D.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 02/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

public struct BoundingBox2D: Hashable {
	
	public var southWest: Coordinate2D
	public var width: Longitude
	public var height: Latitude
	
	public var southLatitude: Latitude {
		southWest.latitude
	}
	public var northLatitude: Latitude {
		southLatitude + height
	}
	public var centerLatitude: Latitude {
		southLatitude + (height / 2.0)
	}
	public var westLongitude: Longitude {
		southWest.longitude
	}
	public var eastLongitude: Longitude {
		let longitude = westLongitude + width
		
		if longitude > .halfRotation {
			return longitude - .fullRotation
		} else {
			return longitude
		}
	}
	public var centerLongitude: Longitude {
		let longitude = westLongitude + (width / 2.0)
		
		if longitude > .halfRotation {
			return longitude - .fullRotation
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
		width: Longitude,
		height: Latitude
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
	
	public func southAtLongitude(_ longitude: Longitude) -> Coordinate2D {
		Coordinate2D(latitude: northEast.latitude, longitude: longitude)
	}
	public func northAtLongitude(_ longitude: Longitude) -> Coordinate2D {
		Coordinate2D(latitude: southWest.latitude, longitude: longitude)
	}
	public func westAtLatitude(_ latitude: Latitude) -> Coordinate2D {
		Coordinate2D(latitude: latitude, longitude: southWest.longitude)
	}
	public func eastAtLatitude(_ latitude: Latitude) -> Coordinate2D {
		Coordinate2D(latitude: latitude, longitude: northEast.longitude)
	}
	
	public func offsetBy(dLat: Latitude = 0, dLong: Longitude = 0) -> BoundingBox2D {
		BoundingBox2D(
			southWest: southWest.offsetBy(dLat: dLat, dLong: dLong),
			northEast: northEast.offsetBy(dLat: dLat, dLong: dLong)
		)
	}
	public func offsetBy(dx: Longitude = 0, dy: Latitude = 0) -> BoundingBox2D {
		BoundingBox2D(
			southWest: southWest.offsetBy(dx: dx, dy: dy),
			northEast: northEast.offsetBy(dx: dx, dy: dy)
		)
	}
	
}

extension BoundingBox2D: BoundingBox {
	
	public static var zero: BoundingBox2D {
		BoundingBox2D(southWest: .zero, width: .zero, height: .zero)
	}
	
	/// The union of bounding boxes gives a new bounding box that encloses the given two.
	public func union(_ other: BoundingBox2D) -> BoundingBox2D {
		BoundingBox2D(
			southWest: Coordinate2D(
				latitude: min(self.southWest.latitude, other.southWest.latitude),
				longitude: min(self.southWest.longitude, other.southWest.longitude)
			),
			northEast: Coordinate2D(
				latitude: max(self.northEast.latitude, other.northEast.latitude),
				longitude: max(self.northEast.longitude, other.northEast.longitude)
			)
		)
	}
	
}
