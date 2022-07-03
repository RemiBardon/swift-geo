//
//  BoundingBox2D.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 02/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import GeoCoordinates

public struct BoundingBox2D: Hashable {
	
	public var southWest: Self.Point
	public var size: Self.Size
	
	public var width: Longitude { self.size.width }
	public var height: Latitude { self.size.height }
	
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
	
	public var northEast: Self.Point {
		Self.Point.init(latitude: northLatitude, longitude: eastLongitude)
	}
	public var northWest: Self.Point {
		Self.Point.init(latitude: northLatitude, longitude: westLongitude)
	}
	public var southEast: Self.Point {
		Self.Point.init(latitude: southLatitude, longitude: westLongitude)
	}
	public var center: Self.Point {
		Self.Point.init(latitude: centerLatitude, longitude: centerLongitude)
	}
	
	public var south: Self.Point {
		southAtLongitude(centerLongitude)
	}
	public var north: Self.Point {
		northAtLongitude(centerLongitude)
	}
	public var west: Self.Point {
		westAtLatitude(centerLatitude)
	}
	public var east: Self.Point {
		eastAtLatitude(centerLatitude)
	}
	
	public var crosses180thMeridian: Bool {
		westLongitude > eastLongitude
	}
	
	public init(southWest: Self.Point, size: Self.Size) {
		self.southWest = southWest
		self.size = size
	}
	
	public init(
		southWest: Self.Point,
		width: Longitude,
		height: Latitude
	) {
		self.init(southWest: southWest, size: Self.Size.init(width: width, height: height))
	}
	
	public init(
		southWest: Self.Point,
		northEast: Self.Point
	) {
		self.init(
			southWest: southWest,
			width: northEast.longitude - southWest.longitude,
			height: northEast.latitude - southWest.latitude
		)
	}
	
	public func southAtLongitude(_ longitude: Longitude) -> Self.Point {
		Self.Point.init(latitude: northEast.latitude, longitude: longitude)
	}
	public func northAtLongitude(_ longitude: Longitude) -> Self.Point {
		Self.Point.init(latitude: southWest.latitude, longitude: longitude)
	}
	public func westAtLatitude(_ latitude: Latitude) -> Self.Point {
		Self.Point.init(latitude: latitude, longitude: southWest.longitude)
	}
	public func eastAtLatitude(_ latitude: Latitude) -> Self.Point {
		Self.Point.init(latitude: latitude, longitude: northEast.longitude)
	}
	
	public func offsetBy(dLat: Latitude = .zero, dLong: Longitude = .zero) -> Self {
		Self.init(
			southWest: southWest.offsetBy(dLat: dLat, dLong: dLong),
			width: width,
			height: height
		)
	}
	public func offsetBy(dx: Self.Coordinates.X = .zero, dy: Self.Coordinates.Y = .zero) -> Self {
		Self.init(
			southWest: southWest.offsetBy(dx: dx, dy: dy),
			width: self.width,
			height: self.height
		)
	}
	
}

extension BoundingBox2D: GeoModels.BoundingBox {
	
	public typealias CoordinateSystem = GeoModels.Geo2D
	
	public var origin: Self.Point { self.southWest }
	
	public init(origin: Self.Point, size: Self.Size) {
		self.init(southWest: origin, size: size)
	}
	
	/// The union of bounding boxes gives a new bounding box that encloses the given two.
	public func union(_ other: Self) -> Self {
		// FIXME: Use width and height, because `eastLongitude` can cross the antimeridian
		Self.init(
			southWest: Coordinate2D(
				latitude: min(self.southLatitude, other.southLatitude),
				longitude: min(self.westLongitude, other.westLongitude)
			),
			northEast: Coordinate2D(
				latitude: max(self.northLatitude, other.northLatitude),
				longitude: max(self.eastLongitude, other.eastLongitude)
			)
		)
	}
	
}

extension BoundingBox2D: CustomDebugStringConvertible {
	
	public var debugDescription: String {
		"BBox2D(southWest: (\(String(reflecting: self.southWest))), northEast: (\(String(reflecting: self.northEast))))"
	}
	
}
