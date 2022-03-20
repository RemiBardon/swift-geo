//
//  Boundable.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 04/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

//import NonEmpty

public protocol Boundable {
	
	associatedtype BoundingBox: GeoModels.BoundingBox
	
	var bbox: BoundingBox { get }
	
}

//extension Coordinate2D: Boundable {}
//
//extension Coordinate3D: Boundable {}
//
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

// Extension of protocol 'Collection' cannot have an inheritance clause
//extension Collection: Boundable where Element: Boundable {
//
//	public var bbox: Element.BoundingBox {
//		self.reduce(.zero, { $0.union($1.bbox) })
//	}
//
//}

//extension Array: Boundable where Element: Boundable {
//
//	public var bbox: Element.BoundingBox {
//		self.reduce(.zero, { $0.union($1.bbox) })
//	}
//
//}
//
//extension Set: Boundable where Element: Boundable {
//
//	public var bbox: Element.BoundingBox {
//		self.reduce(.zero, { $0.union($1.bbox) })
//	}
//
//}
