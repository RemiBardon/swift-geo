//
//  Feature.swift
//  GeoSwift
//
//  Created by Rémi Bardon on 04/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

/// A [GeoJSON Feature](https://datatracker.ietf.org/doc/html/rfc7946#section-3.2).
public struct Feature<
	Geometry: GeoJSON.Geometry & Codable,
	Properties: GeoJSON.FeatureProperties
>: CodableObject {
	
	public static var geoJSONType: GeoJSON.`Type` { .feature }
	
	public var bbox: Geometry.BoundingBox? { geometry?.bbox }
	
	public var geometry: Geometry?
	public var properties: Properties
	
	public init(geometry: Geometry?, properties: Properties) {
		self.geometry = geometry
		self.properties = properties
	}
	
}

/// A (half) type-erased ``Feature``.
public typealias AnyFeature<Properties: GeoJSON.FeatureProperties> = Feature<AnyGeometry, Properties>
