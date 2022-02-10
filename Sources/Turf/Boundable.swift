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
	
	var _bbox: BoundingBox { get }
	
}

extension Boundable {
	
	public var bbox: BoundingBox { _bbox }
	
}

extension Boundable where Self: Hashable {
	
	public var bbox: BoundingBox { BoundingBoxCache.shared.bbox(for: self) }
	
}

extension Coordinate2D {
	
	public var _bbox: BoundingBox2D {
		BoundingBox2D(southWest: self, width: .zero, height: .zero)
	}
	
}

extension Coordinate3D: Boundable {
	
	public var _bbox: BoundingBox3D {
		BoundingBox3D(southWestLow: self, width: .zero, height: .zero, zHeight: .zero)
	}
	
}

extension Line2D: Boundable {
	
	public var _bbox: BoundingBox2D {
		Turf.bbox(for: [start, end])!
	}
	
}

extension Line3D: Boundable {
	
	public var _bbox: BoundingBox3D {
		Turf.bbox(for: [start, end])!
	}
	
}

extension BoundingBox2D: Boundable {
	
	public var _bbox: BoundingBox2D { self }
	
}

extension BoundingBox3D: Boundable {
	
	public var _bbox: BoundingBox3D { self }
	
}

// Extension of protocol 'Collection' cannot have an inheritance clause
//extension Collection: Boundable where Element: Boundable {
//
//	public var _bbox: Element.BoundingBox {
//		self.reduce(nil, { $0.union($1.bbox) }) ?? .zero
//	}
//
//}

extension Array: Boundable where Element: Boundable {
	
	public var _bbox: Element.BoundingBox {
		self.reduce(nil, { $0.union($1.bbox) }) ?? .zero
	}
	
}

extension Set: Boundable where Element: Boundable {
	
	public var _bbox: Element.BoundingBox {
		self.reduce(nil, { $0.union($1.bbox) }) ?? .zero
	}
	
}
