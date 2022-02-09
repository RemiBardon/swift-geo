//
//  FeatureCollection.swift
//  GeoSwift
//
//  Created by Rémi Bardon on 07/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

/// A [GeoJSON FeatureCollection](https://datatracker.ietf.org/doc/html/rfc7946#section-3.3).
public struct FeatureCollection<
//	BoundingBox: GeoJSON.BoundingBox,
	Properties: GeoJSON.FeatureProperties
>: GeoJSON.Object {
	
	public static var geoJSONType: GeoJSON.`Type` { .featureCollection }
	
	public var features: [Feature<Properties>]
	
	// FIXME: Fix bounding box
	public var bbox: AnyBoundingBox? { nil }
	
}
