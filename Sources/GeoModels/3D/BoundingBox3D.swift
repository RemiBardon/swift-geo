//
//  BoundingBox3D.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 08/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

public struct BoundingBox3D: Hashable {
	
	public var twoDimensions: BoundingBox2D
	public var lowAltitude: Altitude
	public var zHeight: Altitude
	
	public var highAltitude: Altitude {
		lowAltitude + zHeight
	}
	public var centerAltitude: Altitude {
		lowAltitude + (zHeight / 2.0)
	}
	
	public var southWestLow: Coordinate3D {
		Coordinate3D(twoDimensions.southWest, altitude: lowAltitude)
	}
	public var northEastHigh: Coordinate3D {
		Coordinate3D(twoDimensions.northEast, altitude: highAltitude)
	}
	public var center: Coordinate3D {
		Coordinate3D(twoDimensions.center, altitude: centerAltitude)
	}
	
	public var crosses180thMeridian: Bool {
		twoDimensions.crosses180thMeridian
	}
	
	public init(_ boundingBox2d: BoundingBox2D, lowAltitude: Altitude, zHeight: Altitude) {
		self.twoDimensions = boundingBox2d
		self.lowAltitude = lowAltitude
		self.zHeight = zHeight
	}
	
	public init(
		southWestLow: Coordinate3D,
		width: Longitude,
		height: Latitude,
		zHeight: Altitude
	) {
		self.init(
			BoundingBox2D(southWest: southWestLow.twoDimensions, width: width, height: height),
			lowAltitude: southWestLow.altitude,
			zHeight: zHeight
		)
	}
	
	public init(
		southWestLow: Coordinate3D,
		northEastHigh: Coordinate3D
	) {
		self.init(
			southWestLow: southWestLow,
			width: northEastHigh.longitude - southWestLow.longitude,
			height: northEastHigh.latitude - southWestLow.latitude,
			zHeight: northEastHigh.altitude - southWestLow.altitude
		)
	}
	
	public func offsetBy(
		dLat: Latitude = .zero,
		dLong: Longitude = .zero,
		dAlt: Altitude = .zero
	) -> BoundingBox3D {
		Self.init(
			twoDimensions.offsetBy(dLat: dLat, dLong: dLong),
			lowAltitude: lowAltitude + dAlt,
			zHeight: zHeight
		)
	}
	public func offsetBy(
		dx: Coordinate3D.X = .zero,
		dy: Coordinate3D.Y = .zero,
		dz: Coordinate3D.Z = .zero
	) -> BoundingBox3D {
		Self.init(
			twoDimensions.offsetBy(dx: dx, dy: dy),
			lowAltitude: lowAltitude + dz,
			zHeight: zHeight
		)
	}
	
}

extension BoundingBox3D: GeoModels.BoundingBox {
	
	public typealias Point = Point3D
	
	public static var zero: BoundingBox3D {
		BoundingBox3D(.zero, lowAltitude: .zero, zHeight: .zero)
	}
	
	public var origin: Point3D { self.southWestLow }
	
	public init(
		origin: (Point3D.X, Point3D.Y, Point3D.Z),
		size:   (Point3D.X, Point3D.Y, Point3D.Z)
	) {
		self.init(southWestLow: Point3D(origin), width: size.0, height: size.1, zHeight: size.2)
	}
	
	/// The union of bounding boxes gives a new bounding box that encloses the given two.
	public func union(_ other: BoundingBox3D) -> BoundingBox3D {
		// FIXME: Use width, height and zHeight, because `eastLongitude` can cross the antimeridian
		BoundingBox3D(
			southWestLow: Coordinate3D(
				self.twoDimensions.union(other.twoDimensions).southWest,
				altitude: min(self.lowAltitude, other.lowAltitude)
			),
			northEastHigh: Coordinate3D(
				self.twoDimensions.union(other.twoDimensions).northEast,
				altitude: max(self.highAltitude, other.highAltitude)
			)
		)
	}
	
}

extension BoundingBox3D: CustomDebugStringConvertible {
	
	public var debugDescription: String {
		"BBox3D(southWestLow: \(String(reflecting: self.southWestLow)), northEastHigh: \(String(reflecting: self.northEastHigh)))"
	}
	
}