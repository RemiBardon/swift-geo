//
//  WGS842D.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 20/03/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import GeoCoordinates
import NonEmpty

public enum WGS842D: GeoModels.CoordinateSystem {

	public typealias Point = WGS84Coordinate2D

	public struct Size: GeoModels.Size {

		public typealias CoordinateSystem = WGS842D
		public typealias RawValue = WGS842D.Point

		public let rawValue: Self.RawValue

		public var width: Self.RawValue.X { self.rawValue.x }
		public var height: Self.RawValue.Y { self.rawValue.y }

		public init(rawValue: Self.RawValue) {
			self.rawValue = rawValue
		}

		public init(width: Self.RawValue.X, height: Self.RawValue.Y) {
			self.init(rawValue: Self.RawValue.init(x: width, y: height))
		}

	}

//	public struct MultiPoint

	public struct Line: GeoModels.Line, Hashable {

		public typealias CoordinateSystem = WGS842D

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

	public struct LineString: GeoModels.LineString, Hashable {

		public typealias CoordinateSystem = WGS842D
		public typealias Points = AtLeast2<[CoordinateSystem.Point]>
		public typealias Lines = NonEmpty<[CoordinateSystem.Line]>

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
		public func offsetBy(dx: Self.Point.X = .zero, dy: Self.Point.Y = .zero) -> Self {
			Self.init(
				southWest: southWest.offsetBy(dx: dx, dy: dy),
				width: self.width,
				height: self.height
			)
		}

	}
	
}

extension WGS842D.BoundingBox: GeoModels.BoundingBox {

	public typealias CoordinateSystem = WGS842D

	public var origin: Self.Point { self.southWest }

	public init(origin: Self.Point, size: Self.Size) {
		self.init(southWest: origin, size: size)
	}

	/// The union of bounding boxes gives a new bounding box that encloses the given two.
	public func union(_ other: Self) -> Self {
		// FIXME: Use width and height, because `eastLongitude` can cross the antimeridian
		Self.init(
			southWest: Self.Point(
				latitude: min(self.southLatitude, other.southLatitude),
				longitude: min(self.westLongitude, other.westLongitude)
			),
			northEast: Self.Point(
				latitude: max(self.northLatitude, other.northLatitude),
				longitude: max(self.eastLongitude, other.eastLongitude)
			)
		)
	}

}

extension WGS842D.BoundingBox: CustomDebugStringConvertible {

	public var debugDescription: String {
		"BBox2D(southWest: (\(String(reflecting: self.southWest))), northEast: (\(String(reflecting: self.northEast))))"
	}

}

