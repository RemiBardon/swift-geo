//
//  Geodesy.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 01/10/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import Foundation
import ValueWithUnit
import SwiftGeoToolbox

// MARK: - General protocols

public protocol EPSGItem {
	static var epsgName: String { get }
	static var epsgCode: Int { get }
}

// MARK: - Coordinates

public protocol Coordinates<CRS>:
	Hashable,
	AdditiveArithmetic,
	MultiplicativeArithmetic,
	Zeroable,
	SafeRawRepresentable,
	InitializableByNumber,
	CustomStringConvertible,
	CustomDebugStringConvertible
where RawValue == Components
{
	associatedtype CRS: CoordinateReferenceSystem
	typealias Components = CRS.CoordinateSystem.Values

	var components: Components { get }

	init(components: Components)
}

public extension Coordinates {
	var rawValue: RawValue { self.components }
	init(rawValue: RawValue) {
		self.init(components: rawValue)
	}
}

public extension Coordinates {
	var description: String { String(describing: self.components) }
	var debugDescription: String { "[\(CRS.epsgName)]\(String(reflecting: self.components))" }
}

// MARK: 2D Coordinates

public extension Coordinates where CRS.CoordinateSystem: TwoDimensionsCS {
	var x: CRS.CoordinateSystem.Axis1.Value { self.components.0 }
	var y: CRS.CoordinateSystem.Axis2.Value { self.components.1 }

	init(
		x: CRS.CoordinateSystem.Axis1.Value,
		y: CRS.CoordinateSystem.Axis2.Value
	) {
		self.init(components: (x, y))
	}
}

public protocol TwoDimensionsCoordinate<CRS>: Coordinates where CRS: TwoDimensionsCRS {
	typealias X = CRS.CoordinateSystem.Axis1.Value
	typealias Y = CRS.CoordinateSystem.Axis2.Value
	
	var x: X { get }
	var y: Y { get }
	
	init(x: X, y: Y)
}

public extension TwoDimensionsCoordinate {
	var components: Components { (self.x, self.y) }

	init(components: Components) {
		self.init(x: components.0, y: components.1)
	}
	init<Source: BinaryFloatingPoint>(_ value: Source) {
		self.init(x: .init(value), y: .init(value))
	}
	init<Source: BinaryInteger>(_ value: Source) {
		self.init(x: .init(value), y: .init(value))
	}

	static func + (lhs: Self, rhs: Self) -> Self {
		Self.init(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
	}
	static func - (lhs: Self, rhs: Self) -> Self {
		Self.init(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
	}
	static func * (lhs: Self, rhs: Self) -> Self {
		Self.init(x: lhs.x * rhs.x, y: lhs.y * rhs.y)
	}
	static func / (lhs: Self, rhs: Self) -> Self {
		Self.init(x: lhs.x / rhs.x, y: lhs.y / rhs.y)
	}

	func offsetBy(dx: X, dy: Y) -> Self {
		Self(x: self.x + dx, y: self.y + dy)
	}
}

public extension TwoDimensionsCoordinate where CRS: GeographicCRS {
	var latitude: X { self.x }
	var longitude: Y { self.y }
}

public struct Coordinate2DOf<CRS>: TwoDimensionsCoordinate where CRS: TwoDimensionsCRS {
	public static var zero: Self { Self(x: .zero, y: .zero) }

	public let x: X
	public let y: Y
	
	public init(x: X, y: Y) {
		#warning("TODO: Perform validations")
		self.x = x
		self.y = y
	}
	
	public init(latitude: X, longitude: Y) {
		self.init(x: latitude, y: longitude)
	}
}

// MARK: 3D Coordinates

public extension Coordinates where CRS.CoordinateSystem: ThreeDimensionsCS {
	var x: CRS.CoordinateSystem.Axis1.Value { self.components.0 }
	var y: CRS.CoordinateSystem.Axis2.Value { self.components.1 }
	var z: CRS.CoordinateSystem.Axis3.Value { self.components.2 }

	init(
		x: CRS.CoordinateSystem.Axis1.Value,
		y: CRS.CoordinateSystem.Axis2.Value,
		z: CRS.CoordinateSystem.Axis3.Value
	) {
		self.init(components: (x, y, z))
	}
}

public protocol ThreeDimensionsCoordinate<CRS>: Coordinates where CRS: ThreeDimensionsCRS {
	typealias X = CRS.CoordinateSystem.Axis1.Value
	typealias Y = CRS.CoordinateSystem.Axis2.Value
	typealias Z = CRS.CoordinateSystem.Axis3.Value
	
	var x: X { get }
	var y: Y { get }
	var z: Z { get }
	
	init(x: X, y: Y, z: Z)
}

public extension ThreeDimensionsCoordinate {
	var components: Components { (self.x, self.y, self.z) }

	init(components: Components) {
		self.init(x: components.0, y: components.1, z: components.2)
	}
	init<Source: BinaryFloatingPoint>(_ value: Source) {
		self.init(x: .init(value), y: .init(value), z: .init(value))
	}
	init<Source: BinaryInteger>(_ value: Source) {
		self.init(x: .init(value), y: .init(value), z: .init(value))
	}

	static func + (lhs: Self, rhs: Self) -> Self {
		Self.init(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
	}
	static func - (lhs: Self, rhs: Self) -> Self {
		Self.init(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z)
	}
	static func * (lhs: Self, rhs: Self) -> Self {
		Self.init(x: lhs.x * rhs.x, y: lhs.y * rhs.y, z: lhs.z * rhs.z)
	}
	static func / (lhs: Self, rhs: Self) -> Self {
		Self.init(x: lhs.x / rhs.x, y: lhs.y / rhs.y, z: lhs.z / rhs.z)
	}

	func offsetBy(dx: X, dy: Y, dz: Z) -> Self {
		Self(x: self.x + dx, y: self.y + dy, z: self.z + dz)
	}
}

public extension ThreeDimensionsCoordinate where CRS: GeographicCRS {
	var latitude: X { self.x }
	var longitude: Y { self.y }
	var altitude: Z { self.z }
}

public struct Coordinate3DOf<CRS>: ThreeDimensionsCoordinate where CRS: ThreeDimensionsCRS {
	public static var zero: Self { Self(x: .zero, y: .zero, z: .zero) }

	public let x: X
	public let y: Y
	public let z: Z

	public init(x: X, y: Y, z: Z) {
		#warning("TODO: Perform validations")
		self.x = x
		self.y = y
		self.z = z
	}

	public init(latitude: X, longitude: Y, altitude: Z) {
		self.init(x: latitude, y: longitude, z: altitude)
	}
}

// MARK: - Coordinate Reference System (CRS/SRS)

public protocol CoordinateReferenceSystem: EPSGItem {
	associatedtype Datum: DatumProtocol
	associatedtype CoordinateSystem: Geodesy.CoordinateSystem
}

public protocol TwoDimensionsCRS: CoordinateReferenceSystem
where CoordinateSystem: TwoDimensionsCS {}
public protocol ThreeDimensionsCRS: CoordinateReferenceSystem
where CoordinateSystem: ThreeDimensionsCS {}

public protocol GeocentricCRS: CoordinateReferenceSystem, ThreeDimensionsCRS {}
public protocol GeographicCRS: CoordinateReferenceSystem {}

// MARK: - Datum

public protocol DatumProtocol {
	associatedtype Ellipsoid: ReferenceEllipsoid
	associatedtype PrimeMeridian: MeridianProtocol
}

public protocol DatumEnsemble: DatumProtocol, EPSGItem {
	associatedtype PrimaryMember: DatumEnsembleMember
	where PrimaryMember.Ellipsoid == Self.Ellipsoid,
				PrimaryMember.PrimeMeridian == Self.PrimeMeridian
}
public protocol DatumEnsembleMember: DatumProtocol, EPSGItem {}
public protocol DynamicGeodeticDatum: DatumEnsembleMember {}

// MARK: Reference Ellipsoid

public protocol ReferenceEllipsoid: EPSGItem {
	static var semiMajorAxis: Double { get }
	static var semiMinorAxis: Double { get }
	static var inverseFlattening: Double { get }
	static var flattening: Double { get }
	/// Eccentricity of the ellipsoid.
	static var eccentricity: Double { get }
	/// Eccentricity of the ellipsoid, squared.
	/// `e^2 = (a^2 -b^2)/a^2 = 2f -f^2`
	static var e2: Double { get }
	/// `ε = e^2 / (1 - e^2)`
	static var ε: Double { get }
}

public extension ReferenceEllipsoid {
	static var flattening: Double { 1 / inverseFlattening }
	/// Source: <https://en.wikipedia.org/wiki/World_Geodetic_System#Definition>
	static var semiMinorAxis: Double { semiMajorAxis * (1 - flattening) }
	static var eccentricity: Double { sqrt(e2) }
	static var e2: Double { (2 * flattening) - pow(flattening, 2) }
	static var ε: Double { e2 / (1 - e2) }
}

// MARK: Meridian

public protocol MeridianProtocol: EPSGItem {
	static var greenwichLongitude: Double { get }
}

public enum Greenwich: MeridianProtocol {
	public static let epsgName: String = "Greenwich"
	public static let epsgCode: Int = 8901
	public static let greenwichLongitude: Double = 0
}

// MARK: - Coordinate System (CS)

public protocol CoordinateSystem: EPSGItem {
	associatedtype Axes
	associatedtype Values
}

public protocol TwoDimensionsCS: CoordinateSystem
where Axes == (Axis1, Axis2),
			Values == (Axis1.Value, Axis2.Value)
{
	associatedtype Axis1: Axis
	associatedtype Axis2: Axis
}

public protocol ThreeDimensionsCS: CoordinateSystem
where Axes == (Axis1, Axis2, Axis3),
			Values == (Axis1.Value, Axis2.Value, Axis3.Value)
{
	associatedtype Axis1: Axis
	associatedtype Axis2: Axis
	associatedtype Axis3: Axis
}

public enum GeocentricCartesian3DCS: ThreeDimensionsCS {
	public typealias Axis1 = GeocentricX
	public typealias Axis2 = GeocentricY
	public typealias Axis3 = GeocentricZ
	public static let epsgName: String = "Cartesian 3D CS (geocentric)"
	public static let epsgCode: Int = 6500
}

public enum Ellipsoidal3DCS: ThreeDimensionsCS {
	public typealias Axis1 = GeodeticLatitude
	public typealias Axis2 = GeodeticLongitude
	public typealias Axis3 = EllipsoidalHeight
	public static let epsgName: String = "Ellipsoidal 3D CS"
	public static let epsgCode: Int = 6423
}

public enum Ellipsoidal2DCS: TwoDimensionsCS {
	public typealias Axis1 = GeodeticLatitude
	public typealias Axis2 = GeodeticLongitude
	public static let epsgName: String = "Ellipsoidal 2D CS"
	public static let epsgCode: Int = 6422
}

// MARK: Axes

public protocol Axis {
	associatedtype UnitOfMeasurement: Geodesy.UnitOfMeasurement
	associatedtype Value: CoordinateComponent
	static var name: String { get }
	static var abbreviation: String { get }
}

public enum GeocentricX: Axis {
	public typealias UnitOfMeasurement = Meter
	public struct Value: CoordinateComponent {
		public var rawValue: DoubleOf<Meter>
		public init(rawValue: RawValue) {
			self.rawValue = rawValue
		}
	}
	public static let name: String = "Geocentric X"
	public static let abbreviation: String = "X"
}

public enum GeocentricY: Axis {
	public typealias UnitOfMeasurement = Meter
	public struct Value: CoordinateComponent {
		public var rawValue: DoubleOf<Meter>
		public init(rawValue: RawValue) {
			self.rawValue = rawValue
		}
	}
	public static let name: String = "Geocentric Y"
	public static let abbreviation: String = "Y"
}

public enum GeocentricZ: Axis {
	public typealias UnitOfMeasurement = Meter
	public struct Value: CoordinateComponent {
		public var rawValue: DoubleOf<Meter>
		public init(rawValue: RawValue) {
			self.rawValue = rawValue
		}
	}
	public static let name: String = "Geocentric Z"
	public static let abbreviation: String = "Z"
}

/// The latitude component of a geographical coordinate.
public enum GeodeticLatitude: Axis {
	public typealias UnitOfMeasurement = Degree

	public struct Value: AngularCoordinateComponent, RawRepresentable {
		public typealias RawValue = DoubleOf<Degree>

		public static let positiveDirectionChar: Character = "N"
		public static let negativeDirectionChar: Character = "S"

		public static var fullRotation: Self = 180
		public static var halfRotation: Self = 90

		public var rawValue: RawValue

		public var decimalDegrees: Double {
			get { self.rawValue.rawValue }
			set { self.rawValue.rawValue = newValue }
		}
		public var positive: Self {
			if decimalDegrees < .zero {
				// `degrees` is negative, so we end up with `180 - |degrees|`
				return self + Self.fullRotation
			} else {
				return self
			}
		}

		public init(decimalDegrees: Double) {
			self.init(rawValue: .init(rawValue: decimalDegrees))
		}

		public init(rawValue: RawValue) {
			self.rawValue = rawValue
		}
	}

	public static let name: String = "Geodetic latitude"
	public static let abbreviation: String = "Lat"
}

public typealias Latitude = GeodeticLatitude.Value

/// The longitude component of a geographical coordinate.
public enum GeodeticLongitude: Axis {
	public typealias UnitOfMeasurement = Degree

	public struct Value: AngularCoordinateComponent, RawRepresentable {
		public typealias RawValue = DoubleOf<Degree>

		public static let positiveDirectionChar: Character = "E"
		public static let negativeDirectionChar: Character = "W"

		public static var fullRotation: Self = 360
		public static var halfRotation: Self = 180

		public var rawValue: DoubleOf<Degree>

		public var decimalDegrees: Double {
			get { self.rawValue.rawValue }
			set { self.rawValue.rawValue = newValue }
		}
		public var positive: Self {
			if decimalDegrees < .zero {
				// `degrees` is negative, so we end up with `360 - |degrees|`
				return self + Self.fullRotation
			} else {
				return self
			}
		}

		public init(decimalDegrees: Double) {
			self.init(rawValue: .init(rawValue: decimalDegrees))
		}

		public init(rawValue: RawValue) {
			self.rawValue = rawValue
		}
	}

	public static let name: String = "Geodetic longitude"
	public static let abbreviation: String = "Lon"
}

public typealias Longitude = GeodeticLongitude.Value

public enum EllipsoidalHeight: Axis {
	public typealias UnitOfMeasurement = Meter

	public struct Value: CoordinateComponent {
		public var rawValue: DoubleOf<Meter>
		public init(rawValue: RawValue) {
			self.rawValue = rawValue
		}
		public static func random() -> Self {
			return Self.random(in: -100...10_000)
		}
	}

	public static let name: String = "Ellipsoidal height"
	public static let abbreviation: String = "h"
}

public typealias Altitude = EllipsoidalHeight.Value

// MARK: - Units of Measurement

public protocol UnitOfMeasurement: EPSGItem, Hashable, Sendable {}

extension Meter: Geodesy.UnitOfMeasurement {
	public static let epsgName: String = "Metre"
	public static let epsgCode: Int = 9001
}

extension Degree: Geodesy.UnitOfMeasurement {
	public static let epsgName: String = "Degree"
	public static let epsgCode: Int = 9122
}
