//
//  GeometryCollection.swift
//  GeoSwift
//
//  Created by Rémi Bardon on 04/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

/// A [GeoJSON GeometryCollection](https://datatracker.ietf.org/doc/html/rfc7946#section-3.1.8).
public struct GeometryCollection: CodableGeometry {
	
	public static var geometryType: GeoJSON.`Type`.Geometry { .geometryCollection }
	
	public var bbox: AnyBoundingBox?
	
	public var asAnyGeometry: AnyGeometry { .geometryCollection(self) }
	
	public var geometries: [AnyGeometry]
	
}
