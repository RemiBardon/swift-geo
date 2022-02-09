//
//  FeatureCollection.swift
//  GeoSwift
//
//  Created by Rémi Bardon on 07/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

/// A [GeoJSON FeatureCollection](https://datatracker.ietf.org/doc/html/rfc7946#section-3.3).
public struct FeatureCollection<
	Geometry: GeoJSON.Geometry & Codable,
	Properties: GeoJSON.FeatureProperties
>: CodableObject {
	
	public static var geoJSONType: GeoJSON.`Type` { .featureCollection }
	
	public var features: [Feature<Geometry, Properties>]
	
	// FIXME: Fix bounding box
	public var bbox: AnyBoundingBox? { nil }
	
}

/// A (half) type-erased ``FeatureCollection``.
public typealias AnyFeatureCollection<
	Properties: GeoJSON.FeatureProperties
> = FeatureCollection<AnyGeometry, Properties>
