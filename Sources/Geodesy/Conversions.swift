//
//  Conversions.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 01/10/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import Foundation

public protocol Conversion<C1, C2> {
	associatedtype C1: Coordinates
	associatedtype C2: Coordinates
	associatedtype EPSGRef: EPSGItem

	static func apply(on coordinate: C1) -> C2
}

public protocol ReversibleConversion: Conversion {
	static func unapply(from coordinate: C2) -> C1
}

// MARK: EPSG 9659 (Geographic 3D to 2D conversions)

public enum EPSG9659Ref: EPSGItem {
	public static let epsgName: String = "Geographic 3D to 2D conversions"
	public static let epsgCode: Int = 9659
}

public enum EPSG9659<C1, C2>: ReversibleConversion
where C1: ThreeDimensionalCoordinates,
			C1.CRS: GeographicCRS,
			C2: TwoDimensionalCoordinates,
			C2.CRS: GeographicCRS,
			C2.CRS.Datum.PrimeMeridian == C1.CRS.Datum.PrimeMeridian
{
	public typealias EPSGRef = EPSG9659Ref

	/// Geographic 3D to 2D conversion.
	///
	/// <https://drive.tiny.cloud/1/4m326iu12oa8re9cjiadxonharclteqb4mumfxj71zsttwkx/5e0ec79e-49fa-4e7a-acca-3d6f6c989877> section 4.1.4
	public static func apply(on coordinate: C1) -> C2 {
		return .init(x: .init(coordinate.x), y: .init(coordinate.y))
	}

	/// Geographic 2D to 3D conversion.
	///
	/// <https://drive.tiny.cloud/1/4m326iu12oa8re9cjiadxonharclteqb4mumfxj71zsttwkx/5e0ec79e-49fa-4e7a-acca-3d6f6c989877> section 4.1.1
	public static func unapply(from coordinate: C2) -> C1 {
		return .init(x: .init(Double(coordinate.x)), y: .init(coordinate.y), z: .init(0.0))
	}
}

public extension ThreeDimensionalCoordinates where CRS: GeographicCRS {
	func transformed<NewCRS, C: Coordinates<NewCRS>>(to _: C.Type) -> C
	where C: TwoDimensionalCoordinates,
				NewCRS: GeographicCRS,
				NewCRS.Datum.PrimeMeridian == CRS.Datum.PrimeMeridian
	{
		EPSG9659<Self, C>.apply(on: self)
	}
	func transformed<NewCRS>(toCRS newCRS: NewCRS.Type) -> Coordinates2D<NewCRS>
	where NewCRS: GeographicCRS & TwoDimensionalCRS,
				NewCRS.Datum.PrimeMeridian == CRS.Datum.PrimeMeridian
	{
		EPSG9659<Self, Coordinates2D<NewCRS>>.apply(on: self)
	}
}

public extension TwoDimensionalCoordinates where CRS: GeographicCRS {
	func transformed<NewCRS, C: Coordinates<NewCRS>>(to _: C.Type) -> C
	where C: ThreeDimensionalCoordinates,
				NewCRS: GeographicCRS,
				NewCRS.Datum.PrimeMeridian == CRS.Datum.PrimeMeridian
	{
		EPSG9659<C, Self>.unapply(from: self)
	}
	func transformed<NewCRS>(toCRS newCRS: NewCRS.Type) -> Coordinates3D<NewCRS>
	where NewCRS: GeographicCRS & ThreeDimensionalCRS,
				NewCRS.Datum.PrimeMeridian == CRS.Datum.PrimeMeridian
	{
		EPSG9659<Coordinates3D<NewCRS>, Self>.unapply(from: self)
	}
}

// MARK: EPSG 9602 (Geographic/geocentric conversions)

public enum EPSG9602Ref: EPSGItem {
	public static let epsgName: String = "Geographic/geocentric conversions"
	public static let epsgCode: Int = 9602
}

public enum EPSG9602<C1, C2>: ReversibleConversion
where C1: ThreeDimensionalCoordinates,
			C1.CRS: GeographicCRS,
			C2: ThreeDimensionalCoordinates,
			C2.CRS: GeocentricCRS,
			C2.CRS.Datum.PrimeMeridian == C1.CRS.Datum.PrimeMeridian
{
	public typealias EPSGRef = EPSG9602Ref

	typealias OldCRS = C1.CRS
	typealias NewCRS = C2.CRS

	/// Geographic to geocentric conversion.
	///
	/// <https://epsg.org/coord-operation-method_9602/Geographic-geocentric-conversions.html>
	/// <https://drive.tiny.cloud/1/4m326iu12oa8re9cjiadxonharclteqb4mumfxj71zsttwkx/5e0ec79e-49fa-4e7a-acca-3d6f6c989877> page 101
	public static func apply(on coordinate: C1) -> C2 {
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

		return .init(x: .init(x), y: .init(y), z: .init(z))
	}

	/// Geocentric to geographic conversion.
	///
	/// <https://epsg.org/coord-operation-method_9602/Geographic-geocentric-conversions.html>
	/// <https://drive.tiny.cloud/1/4m326iu12oa8re9cjiadxonharclteqb4mumfxj71zsttwkx/5e0ec79e-49fa-4e7a-acca-3d6f6c989877> page 101
	public static func unapply(from coordinate: C2) -> C1 {
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

		return .init(x: .init(φ.fromRadians), y: .init(λ.fromRadians), z: .init(h))
	}
}

public extension ThreeDimensionalCoordinates {
	func transformed<NewCRS>(toCRS newCRS: NewCRS.Type) -> Coordinates3D<NewCRS>
	where CRS: GeographicCRS,
				NewCRS: GeocentricCRS & ThreeDimensionalCRS,
				NewCRS.Datum.PrimeMeridian == CRS.Datum.PrimeMeridian
	{
		EPSG9602<Self, Coordinates3D<NewCRS>>.apply(on: self)
	}

	func transformed<NewCRS>(toCRS newCRS: NewCRS.Type) -> Coordinates3D<NewCRS>
	where CRS: GeocentricCRS,
				NewCRS: GeographicCRS & ThreeDimensionalCRS,
				NewCRS.Datum.PrimeMeridian == CRS.Datum.PrimeMeridian
	{
		EPSG9602<Coordinates3D<NewCRS>, Self>.unapply(from: self)
	}
}

fileprivate extension FloatingPoint {
	var toRadians: Self { (self / 180) * Self.pi }
	var fromRadians: Self { (self / Self.pi) * 180 }
}
