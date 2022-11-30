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
	Equatable,
	Zeroable,
	AdditiveArithmetic,
	MultiplicativeArithmetic,
	InitializableByNumber,
	CustomStringConvertible,
	CustomDebugStringConvertible
{
	associatedtype CRS: Geodesy.CoordinateReferenceSystem
}

// MARK: 2D Coordinates

public protocol TwoDimensionalCoordinates<CRS>: Geodesy.Coordinates
where CRS: TwoDimensionalCRS
{
	associatedtype X: CoordinateComponent
	associatedtype Y: CoordinateComponent

	var x: X { get set }
	var y: Y { get set }
	var components: (X, Y) { get set }

	init(x: X, y: Y)
}

public struct Coordinates2DOf<CRS>: TwoDimensionalCoordinates
where CRS: TwoDimensionalCRS
{
	public typealias X = CRS.CoordinateSystem.Axis1.Value
	public typealias Y = CRS.CoordinateSystem.Axis2.Value

	public var x: X
	public var y: Y

	public var components: (X, Y) {
		get { (self.x, self.y) }
		set {
			self.x = newValue.0
			self.y = newValue.1
		}
	}

	public init(x: X, y: Y) {
		#warning("TODO: Perform validations")
		self.x = x
		self.y = y
	}
}

// Zeroable
public extension Coordinates2DOf {
	static var zero: Self { Self.init(x: .zero, y: .zero) }
}

// AdditiveArithmetic
public extension Coordinates2DOf {
	static func + (lhs: Self, rhs: Self) -> Self {
		Self.init(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
	}
	static func - (lhs: Self, rhs: Self) -> Self {
		Self.init(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
	}
}
// MultiplicativeArithmetic
public extension Coordinates2DOf {
	static func * (lhs: Self, rhs: Self) -> Self {
		Self.init(x: lhs.x * rhs.x, y: lhs.y * rhs.y)
	}
	static func / (lhs: Self, rhs: Self) -> Self {
		Self.init(x: lhs.x / rhs.x, y: lhs.y / rhs.y)
	}
}

// InitializableByInteger
public extension Coordinates2DOf {
	init<Source: BinaryInteger>(_ value: Source) {
		self.init(x: .init(value), y: .init(value))
	}
}
// InitializableByFloatingPoint
public extension Coordinates2DOf {
	init<Source: BinaryFloatingPoint>(_ value: Source) {
		self.init(x: .init(value), y: .init(value))
	}
}

// CustomStringConvertible & CustomDebugStringConvertible
public extension Coordinates2DOf {
	var description: String { String(describing: self.components) }
	var debugDescription: String { String(reflecting: self.components) }
}

public extension Coordinates2DOf where CRS: GeographicCRS {
	var latitude: X { self.x }
	var longitude: Y { self.y }
	init(latitude: X, longitude: Y) {
		self.init(x: latitude, y: longitude)
	}
}

public extension Coordinates2DOf
where CRS: GeographicCRS,
			Self.Y: AngularCoordinateComponent
{
	var withPositiveLongitude: Self {
		Self.init(latitude: self.latitude, longitude: self.longitude.positive)
	}
}

// MARK: 3D Coordinates

public protocol ThreeDimensionalCoordinates<CRS>: Geodesy.Coordinates
where CRS: ThreeDimensionalCRS
{
	associatedtype X: CoordinateComponent
	associatedtype Y: CoordinateComponent
	associatedtype Z: CoordinateComponent

	var x: X { get set }
	var y: Y { get set }
	var z: Z { get set }
	var components: (X, Y, Z) { get set }

	init(x: X, y: Y, z: Z)
}

public struct Coordinates3DOf<CRS: ThreeDimensionalCRS>: ThreeDimensionalCoordinates {
	public typealias X = CRS.CoordinateSystem.Axis1.Value
	public typealias Y = CRS.CoordinateSystem.Axis2.Value
	public typealias Z = CRS.CoordinateSystem.Axis3.Value

	public var x: X
	public var y: Y
	public var z: Z

	public var components: (X, Y, Z) {
		get { (self.x, self.y, self.z) }
		set {
			self.x = newValue.0
			self.y = newValue.1
			self.z = newValue.2
		}
	}

	public init(x: X, y: Y, z: Z) {
		#warning("TODO: Perform validations")
		self.x = x
		self.y = y
		self.z = z
	}
}

// Zeroable
public extension Coordinates3DOf {
	static var zero: Self { Self.init(x: .zero, y: .zero, z: .zero) }
}

// AdditiveArithmetic
public extension Coordinates3DOf {
	static func + (lhs: Self, rhs: Self) -> Self {
		Self.init(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
	}
	static func - (lhs: Self, rhs: Self) -> Self {
		Self.init(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z)
	}
}
// MultiplicativeArithmetic
public extension Coordinates3DOf {
	static func * (lhs: Self, rhs: Self) -> Self {
		Self.init(x: lhs.x * rhs.x, y: lhs.y * rhs.y, z: lhs.z * rhs.z)
	}
	static func / (lhs: Self, rhs: Self) -> Self {
		Self.init(x: lhs.x / rhs.x, y: lhs.y / rhs.y, z: lhs.z / rhs.z)
	}
}

// InitializableByInteger
public extension Coordinates3DOf {
	init<Source: BinaryInteger>(_ value: Source) {
		self.init(x: .init(value), y: .init(value), z: .init(value))
	}
}
// InitializableByFloatingPoint
public extension Coordinates3DOf {
	init<Source: BinaryFloatingPoint>(_ value: Source) {
		self.init(x: .init(value), y: .init(value), z: .init(value))
	}
}

// CustomStringConvertible & CustomDebugStringConvertible
public extension Coordinates3DOf {
	var description: String { String(describing: self.components) }
	var debugDescription: String { String(reflecting: self.components) }
}

public extension ThreeDimensionalCoordinates where CRS: GeographicCRS {
	var latitude: X { self.x }
	var longitude: Y { self.y }
	var altitude: Z { self.z }
	init(latitude: X, longitude: Y, altitude: Z) {
		self.init(x: latitude, y: longitude, z: altitude)
	}
}

public extension ThreeDimensionalCoordinates
where CRS: GeographicCRS,
			Self.Y: AngularCoordinateComponent
{
	var withPositiveLongitude: Self {
		Self.init(
			latitude: self.latitude,
			longitude: self.longitude.positive,
			altitude: self.altitude
		)
	}
}

// MARK: - Coordinate Reference System (CRS/SRS)

public protocol CoordinateReferenceSystem: EPSGItem {
	associatedtype Datum: Geodesy.DatumProtocol
	associatedtype CoordinateSystem: Geodesy.CoordinateSystem
	associatedtype Coordinates: Geodesy.Coordinates<Self>
}

public protocol AtLeastTwoDimensionalCRS: CoordinateReferenceSystem
where CoordinateSystem: AtLeastTwoDimensionalCS {}
public protocol TwoDimensionalCRS: AtLeastTwoDimensionalCRS
where CoordinateSystem: TwoDimensionalCS,
			Coordinates: TwoDimensionalCoordinates
{}
public protocol AtLeastThreeDimensionalCRS: AtLeastTwoDimensionalCRS
where CoordinateSystem: AtLeastThreeDimensionalCS {}
public protocol ThreeDimensionalCRS: AtLeastThreeDimensionalCRS
where CoordinateSystem: ThreeDimensionalCS,
			Coordinates: ThreeDimensionalCoordinates
{}

public protocol GeocentricCRS: CoordinateReferenceSystem
where Self.CoordinateSystem: GeocentricCS {}
public protocol GeographicCRS: CoordinateReferenceSystem
where Self.CoordinateSystem: GeographicCS {}

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
}

public protocol AtLeastTwoDimensionalCS: CoordinateSystem {
	associatedtype Axis1: Axis
	associatedtype Axis2: Axis
}
public protocol TwoDimensionalCS: AtLeastTwoDimensionalCS
where Axes == (Axis1, Axis2) {}
public protocol AtLeastThreeDimensionalCS: AtLeastTwoDimensionalCS {
	associatedtype Axis3: Axis
}
public protocol ThreeDimensionalCS: AtLeastThreeDimensionalCS
where Axes == (Axis1, Axis2, Axis3) {}

public protocol GeocentricCS: ThreeDimensionalCS {}
public protocol GeographicCS: CoordinateSystem {}

public enum GeocentricCartesian3DCS: ThreeDimensionalCS, GeocentricCS {
	public typealias Axis1 = GeocentricX
	public typealias Axis2 = GeocentricY
	public typealias Axis3 = GeocentricZ
	public static let epsgName: String = "Cartesian 3D CS (geocentric)"
	public static let epsgCode: Int = 6500
}
public typealias EPSG6500 = GeocentricCartesian3DCS

public enum Ellipsoidal3DCS: ThreeDimensionalCS, GeographicCS {
	public typealias Axis1 = GeodeticLatitude
	public typealias Axis2 = GeodeticLongitude
	public typealias Axis3 = EllipsoidalHeight
	public static let epsgName: String = "Ellipsoidal 3D CS"
	public static let epsgCode: Int = 6423
}
public typealias EPSG6423 = Ellipsoidal3DCS

public enum Ellipsoidal2DCS: TwoDimensionalCS, GeographicCS {
	public typealias Axis1 = GeodeticLatitude
	public typealias Axis2 = GeodeticLongitude
	public static let epsgName: String = "Ellipsoidal 2D CS"
	public static let epsgCode: Int = 6422
}
public typealias EPSG6422 = Ellipsoidal2DCS

// MARK: Axes

public protocol Axis {
	associatedtype UnitOfMeasurement: Geodesy.UnitOfMeasurement
	associatedtype Value: CoordinateComponent<UnitOfMeasurement>
	static var name: String { get }
	static var abbreviation: String { get }
}

public enum GeocentricX: Axis {
	public typealias UnitOfMeasurement = Meter
	public struct Value: CoordinateComponent {
		public typealias Unit = Meter
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
		public typealias Unit = Meter
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
		public typealias Unit = Meter
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
		public typealias Unit = Degree
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
		public typealias Unit = Degree
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
		public typealias Unit = Meter
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

public protocol UnitOfMeasurement: ValueWithUnit.Unit, EPSGItem, Hashable, Sendable {}

extension Meter: Geodesy.UnitOfMeasurement {
	public static let epsgName: String = "Metre"
	public static let epsgCode: Int = 9001
}

extension Degree: Geodesy.UnitOfMeasurement {
	public static let epsgName: String = "Degree"
	public static let epsgCode: Int = 9122
}
