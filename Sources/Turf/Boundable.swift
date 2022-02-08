//
//  Boundable.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 04/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import GeoModels

public protocol Boundable {
	
	associatedtype BoundingBox: GeoModels.BoundingBox
	
	var bbox: BoundingBox { get }
	
}

extension Coordinate2D: Boundable {
	
	public var bbox: BoundingBox2D {
		BoundingBox2D(southWest: self, width: 0, height: 0)
	}
	
}

extension Coordinate3D: Boundable {
	
	public var bbox: BoundingBox3D {
		BoundingBox3D(twoDimensions.bbox, lowAltitude: altitude, zHeight: .zero)
	}
	
}

extension Line2D: Boundable {
	
	public var bbox: BoundingBox2D {
		Turf.bbox(for: [start, end])!
	}
	
}

extension Line3D: Boundable {
	
	public var bbox: BoundingBox3D {
		Turf.bbox(for: [start, end])!
	}
	
}

extension BoundingBox2D: Boundable {
	
	public var bbox: BoundingBox2D { self }
	
}

extension BoundingBox3D: Boundable {
	
	public var bbox: BoundingBox3D { self }
	
}

// Extension of protocol 'Collection' cannot have an inheritance clause
//extension Collection: Boundable where Element: Boundable {
//
//	public var bbox: Element.BoundingBox {
//		self.reduce(.zero, { $0.union($1.bbox) })
//	}
//
//}

extension Array: Boundable where Element: Boundable {
	
	public var bbox: Element.BoundingBox {
		self.reduce(.zero, { $0.union($1.bbox) })
	}
	
}

extension Set: Boundable where Element: Boundable {
	
	public var bbox: Element.BoundingBox {
		self.reduce(.zero, { $0.union($1.bbox) })
	}
	
}
