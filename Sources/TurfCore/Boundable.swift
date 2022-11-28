//
//  Boundable.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 04/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

//import NonEmpty
import GeodeticGeometry

public protocol Boundable<BoundingBox> {
	associatedtype BoundingBox: GeodeticGeometry.BoundingBox & Boundable

	var bbox: BoundingBox { get }

	func union(_ other: Self) -> Self
}

// MARK: - Default implementations

// MARK: Bounding box

extension GeodeticGeometry.BoundingBox {
	public var bbox: Self { self }
}

// MARK: Shapes

extension GeodeticGeometry.Point where Self.Coordinates: Boundable {
	public var bbox: Self.Coordinates.BoundingBox { self.coordinates.bbox }
}

extension GeodeticGeometry.Line where Self.GeometricSystem: GeometricSystemAlgebra {
	public var bbox: Self.GeometricSystem.BoundingBox {
		Self.GeometricSystem.bbox(forCollection: self.points)
	}
}

//extension Line2D: Boundable {
//	
//	public var bbox: BoundingBox2D {
//		Turf.naiveBBox(forCollection: self.points) ?? BoundingBox2D(southWest: self.points.first, width: .zero, height: .zero)
//	}
//	
//}
//
//extension Line3D: Boundable {
//	
//	public var bbox: BoundingBox3D {
//		Turf.naiveBBox(forNonEmptyCollection: self.points)
//	}
//	
//}
//
//extension BoundingBox2D: Boundable {
//	
//	public var bbox: BoundingBox2D { self }
//	
//}
//
//extension BoundingBox3D: Boundable {
//	
//	public var bbox: BoundingBox3D { self }
//	
//}

// MARK: Sequences

extension Sequence where Self.Element: Boundable, Self.Element.BoundingBox: Boundable {
	public var bbox: Self.Element.BoundingBox {
		self.reduce(.zero, { $0.union($1.bbox) })
	}
}
