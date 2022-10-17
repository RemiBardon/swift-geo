////
////  WGS843D.swift
////  SwiftGeo
////
////  Created by Rémi Bardon on 20/03/2022.
////  Copyright © 2022 Rémi Bardon. All rights reserved.
////
//
//import GeodeticGeometry
//import NonEmpty
//
//public enum WGS843D: GeometricSystem {
//	
//	public typealias Point = Coordinate3D
//
//	public struct Size: GeodeticGeometry.Size {
//
//		public typealias CoordinateSystem = WGS843D
//		public typealias RawValue = WGS843D.Point
//
//		public let rawValue: Self.RawValue
//
//		public var width: Self.RawValue.X { self.rawValue.x }
//		public var height: Self.RawValue.Y { self.rawValue.y }
//		public var zHeight: Self.RawValue.Z { self.rawValue.z }
//
//		public init(rawValue: Self.RawValue) {
//			self.rawValue = rawValue
//		}
//
//		public init(width: Self.RawValue.X, height: Self.RawValue.Y, zHeight: Self.RawValue.Z) {
//			self.init(rawValue: Self.RawValue.init(x: width, y: height, z: zHeight))
//		}
//
//	}
//
////	public struct MultiPoint
//
//	public struct Line: GeodeticGeometry.Line, Hashable {
//
//		public typealias CoordinateSystem = WGS843D
//		public typealias Point = WGS843D.Point
//
//		public let start: Point
//		public let end: Point
//
//		public var altitudeDelta: Altitude {
//			end.altitude - start.altitude
//		}
//
//		public init(start: Point, end: Point) {
//			self.start = start
//			self.end = end
//		}
//
//	}
//
////	public struct MultiLine
//
//	public struct LineString: GeodeticGeometry.LineString, Hashable {
//
//		public typealias CoordinateSystem = WGS843D
//		public typealias Points = AtLeast2<[CoordinateSystem.Point]>
//		public typealias Lines = NonEmpty<[CoordinateSystem.Line]>
//
//		public internal(set) var points: Points
//
//		public init(points: Points) {
//			self.points = points
//		}
//
//		public mutating func append(_ point: Self.Point) {
//			self.points.append(point)
//		}
//
//	}
//
////	public struct LinearRing
//	
//	public struct BoundingBox: Hashable {
//
//		public var twoDimensions: LowerDimension
//		public var lowAltitude: Altitude
//		public var zHeight: Altitude
//
//		public var highAltitude: Altitude {
//			lowAltitude + zHeight
//		}
//		public var centerAltitude: Altitude {
//			lowAltitude + (zHeight / 2.0)
//		}
//
//		public var southWestLow: Self.Point {
//			Self.Point.init(twoDimensions.southWest, altitude: lowAltitude)
//		}
//		public var northEastHigh: Self.Point {
//			Self.Point.init(twoDimensions.northEast, altitude: highAltitude)
//		}
//		public var center: Self.Point {
//			Self.Point.init(twoDimensions.center, altitude: centerAltitude)
//		}
//
//		public var crosses180thMeridian: Bool {
//			twoDimensions.crosses180thMeridian
//		}
//
//		public init(_ boundingBox2d: LowerDimension, lowAltitude: Altitude, zHeight: Altitude) {
//			self.twoDimensions = boundingBox2d
//			self.lowAltitude = lowAltitude
//			self.zHeight = zHeight
//		}
//
//		public init(
//			southWestLow: Self.Point,
//			width: Longitude,
//			height: Latitude,
//			zHeight: Altitude
//		) {
//			self.init(
//				Self.LowerDimension(
//					southWest: southWestLow.lowerDimension,
//					width: width,
//					height: height
//				),
//				lowAltitude: southWestLow.altitude,
//				zHeight: zHeight
//			)
//		}
//
//		public init(
//			southWestLow: Self.Point,
//			northEastHigh: Self.Point
//		) {
//			self.init(
//				southWestLow: southWestLow,
//				width: northEastHigh.longitude - southWestLow.longitude,
//				height: northEastHigh.latitude - southWestLow.latitude,
//				zHeight: northEastHigh.altitude - southWestLow.altitude
//			)
//		}
//
//		public func offsetBy(
//			dLat: Latitude = .zero,
//			dLong: Longitude = .zero,
//			dAlt: Altitude = .zero
//		) -> Self {
//			Self.init(
//				twoDimensions.offsetBy(dLat: dLat, dLong: dLong),
//				lowAltitude: lowAltitude + dAlt,
//				zHeight: zHeight
//			)
//		}
//		public func offsetBy(
//			dx: Self.Point.X = .zero,
//			dy: Self.Point.Y = .zero,
//			dz: Self.Point.Z = .zero
//		) -> Self {
//			Self.init(
//				twoDimensions.offsetBy(dx: dx, dy: dy),
//				lowAltitude: lowAltitude + dz,
//				zHeight: zHeight
//			)
//		}
//
//	}
//	
//}
//
//extension WGS843D.Size: GeodeticGeometry.CompoundDimension {
//
//	public typealias LowerDimension = WGS842D.Size
//
//	public var lowerDimension: Self.LowerDimension {
//		LowerDimension(rawValue: self.rawValue.lowerDimension)
//	}
//
//	public init(_ twoDimensions: Self.LowerDimension, zHeight: Self.RawValue.Z) {
//		self.init(rawValue: Self.RawValue.init(
//			x: twoDimensions.width,
//			y: twoDimensions.height,
//			z: zHeight
//		))
//	}
//
//}
//
//extension WGS843D.Line: GeoCoordinates.CompoundDimension {
//
//	public typealias LowerDimension = WGS842D.Line
//
//	public var lowerDimension: LowerDimension {
//		Self.LowerDimension(start: self.start.lowerDimension, end: self.end.lowerDimension)
//	}
//
//}
//
//extension WGS843D.BoundingBox: GeoModels.BoundingBox {
//
//	public typealias CoordinateSystem = WGS843D
//
//	public var origin: Self.Point { self.southWestLow }
//	public var size: Self.Size { Self.Size(self.twoDimensions.size, zHeight: self.zHeight) }
//
//	public init(origin: Self.Point, size: Self.Size) {
//		self.init(
//			southWestLow: origin,
//			width: size.width,
//			height: size.height,
//			zHeight: size.zHeight
//		)
//	}
//
//	/// The union of bounding boxes gives a new bounding box that encloses the given two.
//	public func union(_ other: Self) -> Self {
//		// FIXME: Use width, height and zHeight, because `eastLongitude` can cross the antimeridian
//		Self.init(
//			southWestLow: Self.Point(
//				self.twoDimensions.union(other.twoDimensions).southWest,
//				altitude: min(self.lowAltitude, other.lowAltitude)
//			),
//			northEastHigh: Self.Point(
//				self.twoDimensions.union(other.twoDimensions).northEast,
//				altitude: max(self.highAltitude, other.highAltitude)
//			)
//		)
//	}
//
//}
//
//extension WGS843D.BoundingBox: GeoCoordinates.CompoundDimension {
//
//	public typealias LowerDimension = WGS842D.BoundingBox
//
//	public var lowerDimension: LowerDimension {
//		self.twoDimensions
//	}
//
//}
//
//extension WGS843D.BoundingBox: CustomDebugStringConvertible {
//
//	public var debugDescription: String {
//		"BBox3D(southWestLow: \(String(reflecting: self.southWestLow)), northEastHigh: \(String(reflecting: self.northEastHigh)))"
//	}
//
//}
