//
//  WGS842D.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 20/03/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import GeodeticGeometry
import NonEmpty

public enum WGS842D: TwoDimensionalGeometricSystem {

	public typealias CRS = WGS84Geographic2DCRS

	public struct Point: GeodeticGeometry.Point {
		public typealias CRS = GeometricSystem.CRS
		public typealias GeometricSystem = WGS842D
		public typealias Coordinates = Coordinate2D

		public var coordinates: Coordinate2D

		public init(coordinates: Coordinate2D) {
			self.coordinates = coordinates
		}
	}

	public struct Size: GeodeticGeometry.Size2D {
		public typealias CRS = WGS84Geographic2DCRS
		public typealias GeometricSystem = WGS842D
		public typealias RawValue = GeometricSystem.Coordinates

		public let dx: Self.RawValue.X
		public let dy: Self.RawValue.Y

		public var rawValue: Self.RawValue { Self.RawValue.init(x: self.dx, y: self.dy) }

		public init(dx: Self.RawValue.X, dy: Self.RawValue.Y) {
			self.dx = dx
			self.dy = dy
		}

		public init(rawValue: Self.RawValue) {
			self.init(dx: rawValue.x, dy: rawValue.y)
		}
	}

//	public struct MultiPoint

	public struct Line: GeodeticGeometry.Line, Hashable {

		public typealias CRS = WGS84Geographic2DCRS
		public typealias GeometricSystem = WGS842D
		public typealias Point = GeometricSystem.Point

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

//	public typealias MultiLine = WGS84MultiLine2D

	public struct LineString: GeodeticGeometry.LineString, Hashable {

		public typealias CRS = WGS84Geographic2DCRS
		public typealias GeometricSystem = WGS842D
		public typealias Point = GeometricSystem.Point
		public typealias Points = AtLeast2<[Point]>
		public typealias Line = GeometricSystem.Line
		public typealias Lines = NonEmpty<[Line]>

		public internal(set) var points: Points

		public init(points: Points) {
			self.points = points
		}

		public mutating func append(_ point: Self.Point) {
			self.points.append(point)
		}

	}
	
//	public typealias LinearRing = WGS84LinearRing2D
	
	public struct BoundingBox: Hashable {

		public typealias GeometricSystem = WGS842D

		public var southWest: Self.Coordinates
		public var size: Self.Size

		public var dLat: Latitude { self.size.dx }
		public var dLong: Longitude { self.size.dy }

		public var southLatitude: Latitude {
			southWest.latitude
		}
		public var northLatitude: Latitude {
			southLatitude + dLat
		}
		public var centerLatitude: Latitude {
			southLatitude + (dLat / 2.0)
		}
		public var westLongitude: Longitude {
			southWest.longitude
		}
		public var eastLongitude: Longitude {
			let longitude = westLongitude + dLong

			if longitude > .halfRotation {
				return longitude - .fullRotation
			} else {
				return longitude
			}
		}
		public var centerLongitude: Longitude {
			let longitude = westLongitude + (dLong / 2.0)

			if longitude > .halfRotation {
				return longitude - .fullRotation
			} else {
				return longitude
			}
		}

		public var northEast: Self.Coordinates {
			Self.Coordinates(latitude: northLatitude, longitude: eastLongitude)
		}
		public var northWest: Self.Coordinates {
			Self.Coordinates(latitude: northLatitude, longitude: westLongitude)
		}
		public var southEast: Self.Coordinates {
			Self.Coordinates(latitude: southLatitude, longitude: westLongitude)
		}
		public var center: Self.Coordinates {
			Self.Coordinates(latitude: centerLatitude, longitude: centerLongitude)
		}

//		public var south: Self.Coordinates {
//			southAtLongitude(centerLongitude)
//		}
//		public var north: Self.Coordinates {
//			northAtLongitude(centerLongitude)
//		}
//		public var west: Self.Coordinates {
//			westAtLatitude(centerLatitude)
//		}
//		public var east: Self.Coordinates {
//			eastAtLatitude(centerLatitude)
//		}

		public var crosses180thMeridian: Bool {
			westLongitude > eastLongitude
		}

		public init(southWest: Self.Coordinates, size: Self.Size) {
			self.southWest = southWest
			self.size = size
		}

		public init(
			southWest: Self.Coordinates,
			dLat: Latitude,
			dLong: Longitude
		) {
			self.init(
				southWest: southWest,
				size: Self.Size(dx: dLat, dy: dLong)
			)
		}

		public init(
			southWest: Self.Coordinates,
			northEast: Self.Coordinates
		) {
			self.init(
				southWest: southWest,
				dLat: northEast.latitude - southWest.latitude,
				dLong: northEast.longitude - southWest.longitude
			)
		}

//		public func southAtLongitude(_ longitude: Longitude) -> Self.Coordinates {
//			Self.Coordinates(latitude: northEast.latitude, longitude: longitude)
//		}
//		public func northAtLongitude(_ longitude: Longitude) -> Self.Coordinates {
//			Self.Coordinates(latitude: southWest.latitude, longitude: longitude)
//		}
//		public func westAtLatitude(_ latitude: Latitude) -> Self.Coordinates {
//			Self.Coordinates(latitude: latitude, longitude: southWest.longitude)
//		}
//		public func eastAtLatitude(_ latitude: Latitude) -> Self.Coordinates {
//			Self.Coordinates(latitude: latitude, longitude: northEast.longitude)
//		}
//
//		public func offsetBy(dLat: Latitude = .zero, dLong: Longitude = .zero) -> Self {
//			Self.init(
//				southWest: southWest.offsetBy(dLat: dLat, dLong: dLong),
//				dLat: self.dLat,
//				dLong: self.dLong
//			)
//		}
//		public func offsetBy(dx: Coordinates.X = .zero, dy: Coordinates.Y = .zero) -> Self {
//			Self.init(
//				southWest: southWest.offsetBy(dx: dx, dy: dy),
//				dLat: self.dLat,
//				dLong: self.dLong
//			)
//		}

	}
	
}

public typealias Point2D = WGS842D.Point
public typealias Size2D = WGS842D.Size
public typealias Line2D = WGS842D.Line
public typealias LineString2D = WGS842D.LineString
public typealias BoundingBox2D = WGS842D.BoundingBox

extension WGS842D.BoundingBox: GeodeticGeometry.BoundingBox {

	public var origin: Self.Coordinates { self.southWest }

	public init(origin: Self.Coordinates, size: Self.Size) {
		self.init(southWest: origin, size: size)
	}

//	/// The union of bounding boxes gives a new bounding box that encloses the given two.
//	public func union(_ other: Self) -> Self {
//		// FIXME: Use width and height, because `eastLongitude` can cross the antimeridian
//		Self.init(
//			southWest: Self.Point(coordinates: .init(
//				latitude: min(self.southLatitude, other.southLatitude),
//				longitude: min(self.westLongitude, other.westLongitude)
//			)),
//			northEast: Self.Point(coordinates: .init(
//				latitude: max(self.northLatitude, other.northLatitude),
//				longitude: max(self.eastLongitude, other.eastLongitude)
//			))
//		)
//	}

}

extension WGS842D.BoundingBox: CustomDebugStringConvertible {

	public var debugDescription: String {
		"BBox2D(southWest: (\(String(reflecting: self.southWest))), northEast: (\(String(reflecting: self.northEast))))"
	}

}
