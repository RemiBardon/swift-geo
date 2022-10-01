//
//  Geodesy.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 01/10/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import Foundation
import Tagged

// MARK: - Coordinates

public protocol Coordinate<CRS>: Hashable, CustomStringConvertible {
	associatedtype CRS: CoordinateReferenceSystem
	typealias Components = CRS.CoordinateSystem.Values

	var components: Components { get }

	init(components: Components)
}

public extension Coordinate {
	var description: String { "[\(CRS.name)]\(String(describing: self.components))" }
}

// MARK: 2D Coordinates

public extension Coordinate where CRS.CoordinateSystem: TwoDimensionsCS {
	var x: CRS.CoordinateSystem.Axis1.Value { self.components.0 }
	var y: CRS.CoordinateSystem.Axis2.Value { self.components.1 }

	init(
		x: CRS.CoordinateSystem.Axis1.Value,
		y: CRS.CoordinateSystem.Axis2.Value
	) {
		self.init(components: (x, y))
	}
}

public protocol TwoDimensionsCoordinate<CRS>: Coordinate where CRS: TwoDimensionsCRS {
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
}

public struct Coordinate2DOf<CRS>: TwoDimensionsCoordinate where CRS: TwoDimensionsCRS {
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

public extension Coordinate where CRS.CoordinateSystem: ThreeDimensionsCS {
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

public protocol ThreeDimensionsCoordinate<CRS>: Coordinate where CRS: ThreeDimensionsCRS {
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
}

public struct Coordinate3DOf<CRS>: ThreeDimensionsCoordinate where CRS: ThreeDimensionsCRS {
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

public protocol CoordinateReferenceSystem {
	associatedtype Datum: DatumProtocol
	associatedtype CoordinateSystem: Geodesy.CoordinateSystem
	static var name: String { get }
	static var code: Int { get }
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

public protocol DatumEnsemble: DatumProtocol {
	associatedtype PrimaryMember: DatumEnsembleMember
	where PrimaryMember.Ellipsoid == Self.Ellipsoid,
				PrimaryMember.PrimeMeridian == Self.PrimeMeridian
	static var name: String { get }
	static var code: Int { get }
}
public protocol DatumEnsembleMember: DatumProtocol {
	static var name: String { get }
	static var code: Int { get }
}
public protocol DynamicGeodeticDatum: DatumEnsembleMember {}

// MARK: Reference Ellipsoid

public protocol ReferenceEllipsoid {
	static var name: String { get }
	static var code: Int { get }
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

public protocol MeridianProtocol {
	static var name: String { get }
	static var code: Int { get }
	static var greenwichLongitude: Double { get }
}

public enum Greenwich: MeridianProtocol {
	public static let name: String = "Greenwich"
	public static let code: Int = 8901
	public static let greenwichLongitude: Double = 0
}

// MARK: - Coordinate System (CS)

public protocol CoordinateSystem {
	associatedtype Axes
	associatedtype Values
	static var name: String { get }
	static var code: Int { get }
}

public protocol TwoDimensionsCS: CoordinateSystem
where Axes == (Axis1, Axis2),
			Values == (Axis1.Value, Axis2.Value)
{
	associatedtype Axis1: Axis
	associatedtype Axis2: Axis
	//	associatedtype Axes = (Axis1, Axis2)
	//	associatedtype Values = (Axis1.Value, Axis2.Value)
}

public protocol ThreeDimensionsCS: CoordinateSystem
where Axes == (Axis1, Axis2, Axis3),
			Values == (Axis1.Value, Axis2.Value, Axis3.Value)
{
	associatedtype Axis1: Axis
	associatedtype Axis2: Axis
	associatedtype Axis3: Axis
	//	associatedtype Axes = (Axis1, Axis2, Axis3)
	//	associatedtype Values = (Axis1.Value, Axis2.Value, Axis3.Value)
}

public enum GeocentricCartesian3DCS: ThreeDimensionsCS {
	public typealias Axis1 = GeocentricX
	public typealias Axis2 = GeocentricY
	public typealias Axis3 = GeocentricZ
	public static let name: String = "Cartesian 3D CS (geocentric)"
	public static let code: Int = 6500
}

public enum Ellipsoidal3DCS: ThreeDimensionsCS {
	public typealias Axis1 = GeodeticLatitude
	public typealias Axis2 = GeodeticLongitude
	public typealias Axis3 = EllipsoidalHeight
	public static let name: String = "Ellipsoidal 3D CS"
	public static let code: Int = 6423
}

public enum Ellipsoidal2DCS: TwoDimensionsCS {
	public typealias Axis1 = GeodeticLatitude
	public typealias Axis2 = GeodeticLongitude
	public static let name: String = "Ellipsoidal 2D CS"
	public static let code: Int = 6422
}

// MARK: Axes

public protocol Axis {
	associatedtype UnitOfMeasurement: UnitOfMeasurementProtocol
	associatedtype Value: BinaryFloatingPoint
	static var name: String { get }
	static var abbreviation: String { get }
}

public extension Axis {
	typealias Value = Tagged<Self, Double>
}

public enum GeocentricX: Axis {
	public typealias UnitOfMeasurement = Metre
	public static let name: String = "Geocentric X"
	public static let abbreviation: String = "X"
}

public enum GeocentricY: Axis {
	public typealias UnitOfMeasurement = Metre
	public static let name: String = "Geocentric Y"
	public static let abbreviation: String = "Y"
}

public enum GeocentricZ: Axis {
	public typealias UnitOfMeasurement = Metre
	public static let name: String = "Geocentric Z"
	public static let abbreviation: String = "Z"
}

public enum GeodeticLatitude: Axis {
	public typealias UnitOfMeasurement = Degree
	public static let name: String = "Geodetic latitude"
	public static let abbreviation: String = "Lat"
}

public enum GeodeticLongitude: Axis {
	public typealias UnitOfMeasurement = Degree
	public static let name: String = "Geodetic longitude"
	public static let abbreviation: String = "Lon"
}

public enum EllipsoidalHeight: Axis {
	public typealias UnitOfMeasurement = Metre
	public static let name: String = "Ellipsoidal height"
	public static let abbreviation: String = "h"
}

// MARK: - Units of Measurement

public protocol UnitOfMeasurementProtocol: Hashable, Sendable {
	static var name: String { get }
	static var code: Int { get }
}

public protocol Length: UnitOfMeasurementProtocol {}

public protocol Angle: UnitOfMeasurementProtocol {}

public enum Metre: Length {
	public static let name: String = "Metre"
	public static let code: Int = 9001
}

public enum Degree: Angle {
	public static let name: String = "Degree"
	public static let code: Int = 9122
}
