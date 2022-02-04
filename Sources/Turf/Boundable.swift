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

extension Line2D: Boundable {
	
	public var bbox: BoundingBox2D {
		Turf.bbox(for: [start, end])!
	}
	
}

extension BoundingBox2D: Boundable {
	
	public var bbox: BoundingBox2D { self }
	
}
