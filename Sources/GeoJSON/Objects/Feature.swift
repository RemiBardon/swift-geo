//
//  Feature.swift
//  GeoSwift
//
//  Created by Rémi Bardon on 04/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

public struct Feature<
//	Geometry: GeoJSON.Geometry,
//	BoundingBox: GeoJSON.BoundingBox,
	Properties: GeoJSON.Properties
>: GeoJSON.Object {
	
	public static var geoJSONType: GeoJSON.`Type` { .feature }
	
	public var bbox: AnyBoundingBox? { geometry?.bbox }
	
	public var geometry: AnyGeometry?
	public var properties: Properties
	
	public init(geometry: AnyGeometry?, properties: Properties) {
		self.geometry = geometry
		self.properties = properties
	}
	
}
