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
	
	public func offsetBy(dLat: Latitude = .zero, dLong: Longitude = .zero) -> BoundingBox2D {
		Self.init(
			southWest: southWest.offsetBy(dLat: dLat, dLong: dLong),
			width: width,
			height: height
		)
	}
	public func offsetBy(dx: Coordinate2D.X = .zero, dy: Coordinate2D.Y = .zero) -> BoundingBox2D {
		Self.init(
			southWest: southWest.offsetBy(dx: dx, dy: dy),
			width: width,
			height: height
		)
	}
	
}

extension BoundingBox2D: GeoModels.BoundingBox {
	
	public typealias Point = Point2D
	
	public static var zero: BoundingBox2D {
		Self.init(southWest: .zero, width: .zero, height: .zero)
	}
	
	public var origin: Point2D { self.southWest }
	
	public init(origin: Point2D.Components, size: Point2D.Components) {
		self.init(southWest: Point2D(origin), width: size.0, height: size.1)
	}
	
	/// The union of bounding boxes gives a new bounding box that encloses the given two.
	public func union(_ other: BoundingBox2D) -> BoundingBox2D {
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
