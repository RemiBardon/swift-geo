//
//  GeoModels+Turf.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 26/03/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import GeoModels

protocol CoordinateSystemAlgebra: GeoModels.CoordinateSystem {
	
	func naiveBBox<Points: Collection>(forCollection points: Points) -> Self.BoundingBox?
		where Points.Element == Self.Point
	
}

extension GeoModels.Geo2D: CoordinateSystemAlgebra {
	
	func naiveBBox<Points: Collection>(forCollection points: Points) -> Self.BoundingBox?
	where Points.Element == Self.Point
	{
		guard let (south, north) = points.map(\.latitude).minAndMax(),
			  let (west, east) = points.map(\.longitude).minAndMax()
		else { return nil }
		
		return Self.BoundingBox(
			southWest: Point2D(latitude: south, longitude: west),
			northEast: Point2D(latitude: north, longitude: east)
		)
	}
	
}

extension GeoModels.Geo3D: CoordinateSystemAlgebra {
	
	func naiveBBox<Points: Collection>(forCollection points: Points) -> Self.BoundingBox?
	where Points.Element == Self.Point
	{
		guard let (south, north) = points.map(\.latitude).minAndMax(),
			  let (west, east) = points.map(\.longitude).minAndMax(),
			  let (low, high) = points.map(\.altitude).minAndMax()
		else { return nil }
		
		return Self.BoundingBox(
			southWestLow: Point3D(latitude: south, longitude: west, altitude: low),
			northEastHigh: Point3D(latitude: north, longitude: east, altitude: high)
		)
	}
	
}
