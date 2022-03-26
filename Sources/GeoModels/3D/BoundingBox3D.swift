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
	
	public var southWestLow: Self.Point {
		Self.Point.init(twoDimensions.southWest, altitude: lowAltitude)
	}
	public var northEastHigh: Self.Point {
		Self.Point.init(twoDimensions.northEast, altitude: highAltitude)
	}
	public var center: Self.Point {
		Self.Point.init(twoDimensions.center, altitude: centerAltitude)
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
			BoundingBox2D(southWest: southWestLow.lowerDimension, width: width, height: height),
			lowAltitude: southWestLow.altitude,
			zHeight: zHeight
		)
	}
	
	public init(
		southWestLow: Self.Point,
		northEastHigh: Self.Point
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
	
	public typealias CoordinateSystem = Geo3D
	
	public var origin: Self.Point { self.southWestLow }
	public var size: Self.Size { Self.Size(self.twoDimensions.size, zHeight: self.zHeight) }
	
	public init(origin: Self.Point, size: Self.Size) {
		self.init(
			southWestLow: origin,
			width: size.width,
			height: size.height,
			zHeight: size.zHeight
		)
	}
	
	/// The union of bounding boxes gives a new bounding box that encloses the given two.
	public func union(_ other: Self) -> Self {
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
