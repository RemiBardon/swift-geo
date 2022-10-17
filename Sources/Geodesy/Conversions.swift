//
//  Conversions.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 01/10/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import Foundation

public protocol Conversion<OldCRS, NewCRS> {
	associatedtype OldCRS: CoordinateReferenceSystem
	associatedtype NewCRS: CoordinateReferenceSystem

//	static var name: String { get }
//	static var code: Int { get }

	static func apply<C1: Coordinates<OldCRS>, C2: Coordinates<NewCRS>>(on coordinate: C1) -> C2
}

public protocol ReversibleConversion: Conversion {
	static func unapply<C1: Coordinates<OldCRS>, C2: Coordinates<NewCRS>>(from coordinate: C2) -> C1
}

// MARK: EPSG 9659 (Geographic 3D to 2D conversions)

public enum EPSG9659<OldCRS, NewCRS>: ReversibleConversion
where OldCRS: GeographicCRS & ThreeDimensionsCRS,
			NewCRS: GeographicCRS & TwoDimensionsCRS,
			NewCRS.Datum.PrimeMeridian == OldCRS.Datum.PrimeMeridian
{
	// FIXME: Static stored properties not supported in generic types
//	static let name: String = "Geographic 3D to 2D conversions"
//	static let code: Int = 9659

	/// Geographic 3D to 2D conversion.
	///
	/// <https://drive.tiny.cloud/1/4m326iu12oa8re9cjiadxonharclteqb4mumfxj71zsttwkx/5e0ec79e-49fa-4e7a-acca-3d6f6c989877> section 4.1.4
	public static func apply<C1: Coordinates<OldCRS>, C2: Coordinates<NewCRS>>(on coordinate: C1) -> C2 {
		return C2.init(x: .init(coordinate.x), y: .init(coordinate.y))
	}

	/// Geographic 2D to 3D conversion.
	///
	/// <https://drive.tiny.cloud/1/4m326iu12oa8re9cjiadxonharclteqb4mumfxj71zsttwkx/5e0ec79e-49fa-4e7a-acca-3d6f6c989877> section 4.1.1
	public static func unapply<C1: Coordinates<OldCRS>, C2: Coordinates<NewCRS>>(from coordinate: C2) -> C1 {
		return C1.init(x: .init(Double(coordinate.x)), y: .init(coordinate.y), z: .init(0.0))
	}
}

public extension ThreeDimensionsCoordinate {
	func transformed<NewCRS>(to newCRS: NewCRS.Type) -> Coordinate2DOf<NewCRS>
	where CRS: GeographicCRS,
				NewCRS: GeographicCRS & TwoDimensionsCRS,
				NewCRS.Datum.PrimeMeridian == CRS.Datum.PrimeMeridian
	{
		EPSG9659<CRS, NewCRS>.apply(on: self)
	}
}

public extension TwoDimensionsCoordinate {
	func transformed<NewCRS>(to newCRS: NewCRS.Type) -> Coordinate3DOf<NewCRS>
	where CRS: GeographicCRS,
				NewCRS: GeographicCRS & ThreeDimensionsCRS,
				NewCRS.Datum.PrimeMeridian == CRS.Datum.PrimeMeridian
	{
		EPSG9659<NewCRS, CRS>.unapply(from: self)
	}
}

// MARK: EPSG 9602 (Geographic/geocentric conversions)

public enum EPSG9602<OldCRS, NewCRS>: ReversibleConversion
where OldCRS: GeographicCRS & ThreeDimensionsCRS,
			NewCRS: GeocentricCRS & ThreeDimensionsCRS,
			NewCRS.Datum.PrimeMeridian == OldCRS.Datum.PrimeMeridian
{
	// FIXME: Static stored properties not supported in generic types
//	static let name: String = "Geographic/geocentric conversions"
//	static let code: Int = 9602

	/// Geographic to geocentric conversion.
	///
	/// <https://epsg.org/coord-operation-method_9602/Geographic-geocentric-conversions.html>
	/// <https://drive.tiny.cloud/1/4m326iu12oa8re9cjiadxonharclteqb4mumfxj71zsttwkx/5e0ec79e-49fa-4e7a-acca-3d6f6c989877> page 101
	public static func apply<C1: Coordinates<OldCRS>, C2: Coordinates<NewCRS>>(on coordinate: C1) -> C2 {
		// φ and λ are respectively the latitude and longitude (related to Greenwich) of the point
		let φ = Double(coordinate.x).toRadians
		let λ = Double(coordinate.y).toRadians
		// Height above the ellipsoid (topographic height plus geoidal height)
		let h = Double(coordinate.z)

		let a = NewCRS.Datum.Ellipsoid.semiMajorAxis
		let e2 = NewCRS.Datum.Ellipsoid.e2

		// ν = a / (1 - e^2*sin^2(φ))^0.5
		let ν = a / sqrt(1 - e2 * sin(sin(φ)))

		let x = (ν + h) * cos(φ) * cos(λ)
		let y = (ν + h) * cos(φ) * sin(λ)
		let z = ((1 - e2) * ν + h) * sin(φ)

		return C2.init(x: .init(x), y: .init(y), z: .init(z))
	}

	/// Geocentric to geographic conversion.
	///
	/// <https://epsg.org/coord-operation-method_9602/Geographic-geocentric-conversions.html>
	/// <https://drive.tiny.cloud/1/4m326iu12oa8re9cjiadxonharclteqb4mumfxj71zsttwkx/5e0ec79e-49fa-4e7a-acca-3d6f6c989877> page 101
	public static func unapply<C1: Coordinates<OldCRS>, C2: Coordinates<NewCRS>>(from coordinate: C2) -> C1 {
		let x = Double(coordinate.x)
		let y = Double(coordinate.y)
		let z = Double(coordinate.z)

		let a = NewCRS.Datum.Ellipsoid.semiMajorAxis
		let b = NewCRS.Datum.Ellipsoid.semiMinorAxis
		let e2 = NewCRS.Datum.Ellipsoid.e2
		let ε = NewCRS.Datum.Ellipsoid.ε

		// p = (X^2 + Y^2)^0.5
		let p = sqrt(pow(x, 2) + pow(y, 2))
		// q = atan2[(Z a) , (p b)]
		let q = atan2(z * a, p * b)

		// φ = atan2[(Z + ε b sin^3(q)) , (p - e^2 a cos^3(q))]
		let φ = atan2(z + ε * b * sin(sin(sin(q))), p - e2 * a * cos(cos(cos(q))))
		// λ = atan2(Y, X)
		let λ = atan2(y, x)
		// ν = a / (1 - e^2*sin^2(φ))^0.5
		let ν = a / sqrt(1 - e2 * sin(sin(φ)))
		// h = (p / cos φ) - ν
		let h = (p / cos(φ)) - ν

		return C1.init(x: .init(φ.fromRadians), y: .init(λ.fromRadians), z: .init(h))
	}
}

public extension ThreeDimensionsCoordinate {
	func transformed<NewCRS>(to newCRS: NewCRS.Type) -> Coordinate3DOf<NewCRS>
	where CRS: GeographicCRS,
				NewCRS: GeocentricCRS & ThreeDimensionsCRS,
				NewCRS.Datum.PrimeMeridian == CRS.Datum.PrimeMeridian
	{
		EPSG9602<CRS, NewCRS>.apply(on: self)
	}

	func transformed<NewCRS>(to newCRS: NewCRS.Type) -> Coordinate3DOf<NewCRS>
	where CRS: GeocentricCRS,
				NewCRS: GeographicCRS & ThreeDimensionsCRS,
				NewCRS.Datum.PrimeMeridian == CRS.Datum.PrimeMeridian
	{
		EPSG9602<NewCRS, CRS>.unapply(from: self)
	}
}

fileprivate extension FloatingPoint {
	var toRadians: Self { (self / 180) * Self.pi }
	var fromRadians: Self { (self / Self.pi) * 180 }
}
