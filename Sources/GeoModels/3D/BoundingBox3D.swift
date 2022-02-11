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

extension BoundingBox3D: BoundingBox {
	
	public static var zero: BoundingBox3D {
		BoundingBox3D(.zero, lowAltitude: .zero, zHeight: .zero)
	}
	
	/// The union of bounding boxes gives a new bounding box that encloses the given two.
	public func union(_ other: BoundingBox3D) -> BoundingBox3D {
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

extension BoundingBox3D {
	
	public func union(_ bbox2d: BoundingBox2D) -> BoundingBox3D {
		let other = BoundingBox3D(bbox2d, lowAltitude: self.lowAltitude, zHeight: .zero)
		return self.union(other)
	}
	
}
