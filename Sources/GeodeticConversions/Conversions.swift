//
//  Conversions.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 30/11/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import Geodesy
import WGS84Core

public extension ThreeDimensionalCoordinates {
	/// Transforms a geographic 3D coordinate into a geographic 2D one.
	func to2D<NewCRS>(_: NewCRS.Type) -> NewCRS.Coordinates
	where Self.CRS: GeographicCRS,
				NewCRS: GeographicCRS & TwoDimensionalCRS,
				NewCRS.Datum.PrimeMeridian == Self.CRS.Datum.PrimeMeridian
	{
		EPSG9659.apply(on: self)
	}
	/// Override of ``Coordinates/to`` using the `to2D` transitive definition.
	func to<NewCRS>(_ newCRS: NewCRS.Type) -> NewCRS.Coordinates
	where Self.CRS: GeographicCRS,
				NewCRS: GeographicCRS & TwoDimensionalCRS,
				NewCRS.Datum.PrimeMeridian == Self.CRS.Datum.PrimeMeridian
	{
		self.to2D(newCRS)
	}

	/// Transforms a geographic 3D coordinate into a geocentric 3D one.
	func toGeocentric<NewCRS>(_: NewCRS.Type) -> NewCRS.Coordinates
	where Self.CRS: GeographicCRS,
				NewCRS: GeocentricCRS & ThreeDimensionalCRS,
				NewCRS.Datum.PrimeMeridian == Self.CRS.Datum.PrimeMeridian
	{
		EPSG9602.apply(on: self)
	}
	/// Override of ``Coordinates/to`` using the `toGeocentric` transitive definition.
	func to<NewCRS>(_ newCRS: NewCRS.Type) -> NewCRS.Coordinates
	where Self.CRS: GeographicCRS,
				NewCRS: GeocentricCRS & ThreeDimensionalCRS,
				NewCRS.Datum.PrimeMeridian == Self.CRS.Datum.PrimeMeridian
	{
		self.toGeocentric(newCRS)
	}

	/// Transforms a geocentric 3D coordinate into a geographic 3D one.
	func toGeographic<NewCRS>(_: NewCRS.Type) -> NewCRS.Coordinates
	where Self.CRS: GeocentricCRS,
				NewCRS: GeographicCRS & ThreeDimensionalCRS,
				NewCRS.Datum.PrimeMeridian == Self.CRS.Datum.PrimeMeridian
	{
		EPSG9602.unapply(from: self)
	}
	/// Override of ``Coordinates/to`` using the `toGeographic` transitive definition.
	func to<NewCRS>(_ newCRS: NewCRS.Type) -> NewCRS.Coordinates
	where Self.CRS: GeocentricCRS,
				NewCRS: GeographicCRS & ThreeDimensionalCRS,
				NewCRS.Datum.PrimeMeridian == Self.CRS.Datum.PrimeMeridian
	{
		self.toGeographic(newCRS)
	}
}

public extension TwoDimensionalCoordinates {
	/// Transforms a geographic 2D coordinate into a geographic 3D one.
	func to3D<NewCRS>(_: NewCRS.Type) -> NewCRS.Coordinates
	where NewCRS: GeographicCRS & ThreeDimensionalCRS,
				Self.CRS: GeographicCRS,
				Self.CRS.Datum.PrimeMeridian == NewCRS.Datum.PrimeMeridian
	{
		EPSG9659.unapply(from: self)
	}
	/// Override of ``Coordinates/to`` using the `to3D` transitive definition.
	func to<NewCRS>(_ newCRS: NewCRS.Type) -> NewCRS.Coordinates
	where NewCRS: GeographicCRS & ThreeDimensionalCRS,
				Self.CRS: GeographicCRS,
				Self.CRS.Datum.PrimeMeridian == NewCRS.Datum.PrimeMeridian
	{
		self.to3D(newCRS)
	}
}
