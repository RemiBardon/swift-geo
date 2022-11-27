//
//  WGS843D.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 20/03/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import GeodeticGeometry
import NonEmpty

public enum WGS843D: ThreeDimensionalGeometricSystem {

	public typealias CRS = WGS84Geographic3DCRS

	public struct Point: GeodeticGeometry.Point {
		public typealias CRS = GeometricSystem.CRS
		public typealias GeometricSystem = WGS843D
		public typealias Coordinates = Coordinate3D

		public var coordinates: Coordinate3D

		public init(coordinates: Coordinate3D) {
			self.coordinates = coordinates
		}
	}

	public struct Size: GeodeticGeometry.Size3D {
		public typealias CRS = WGS84Geographic3DCRS
		public typealias GeometricSystem = WGS843D
		public typealias RawValue = GeometricSystem.Coordinates

		public let dx: Self.RawValue.X
		public let dy: Self.RawValue.Y
		public let dz: Self.RawValue.Z

		public var rawValue: Self.RawValue {
			Self.RawValue.init(x: self.dx, y: self.dy, z: self.dz)
		}

		public init(dx: Self.RawValue.X, dy: Self.RawValue.Y, dz: Self.RawValue.Z) {
			self.dx = dx
			self.dy = dy
			self.dz = dz
		}

		public init(rawValue: Self.RawValue) {
			self.init(dx: rawValue.x, dy: rawValue.y, dz: rawValue.z)
		}
	}

//	public struct MultiPoint

	public struct Line: GeodeticGeometry.Line, Hashable {

		public typealias CRS = WGS84Geographic3DCRS
		public typealias GeometricSystem = WGS843D
		public typealias Point = GeometricSystem.Point

		public let start: Self.Point
		public let end: Self.Point

		public var altitudeDelta: Altitude {
			end.altitude - start.altitude
		}

		public init(start: Point, end: Point) {
			self.start = start
			self.end = end
		}

	}

//	public struct MultiLine

	public struct LineString: GeodeticGeometry.LineString, Hashable {

		public typealias CRS = WGS84Geographic3DCRS
		public typealias GeometricSystem = WGS843D
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

//	public struct LinearRing

	public struct BoundingBox: GeodeticGeometry.BoundingBox {

		public typealias GeometricSystem = WGS843D
		public typealias Point = GeometricSystem.Point
		public typealias Size = GeometricSystem.Size

		public var origin: Self.Point
		public var size: Self.Size

		public init(origin: Point, size: Size) {
			self.origin = origin
			self.size = size
		}

	}

}

public typealias Point3D = WGS843D.Point
public typealias Size3D = WGS843D.Size
public typealias Line3D = WGS843D.Line
public typealias LineString3D = WGS843D.LineString
public typealias BoundingBox3D = WGS843D.BoundingBox

extension WGS843D.BoundingBox: CustomDebugStringConvertible {

	public var debugDescription: String {
		"BBox3D(origin: \(String(reflecting: self.origin)), size: \(String(reflecting: self.size)))"
	}

}
