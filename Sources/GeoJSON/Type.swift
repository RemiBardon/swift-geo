//
//  Type.swift
//  GeoSwift
//
//  Created by Rémi Bardon on 07/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

public enum `Type`: Hashable, Codable, RawRepresentable {
	
	public enum Geometry: String, Hashable, Codable {
		case point = "Point"
		case multiPoint = "MultiPoint"
		case lineString = "LineString"
		case multiLineString = "MultiLineString"
		case polygon = "Polygon"
		case multiPolygon = "MultiPolygon"
		case geometryCollection = "GeometryCollection"
	}
	
	case geometry(Geometry)
	case feature
	case featureCollection
	
	public var rawValue: String {
		switch self {
		case .geometry(let geometry):
			return geometry.rawValue
		case .feature:
			return "Feature"
		case .featureCollection:
			return "FeatureCollection"
		}
	}
	
	public init?(rawValue: String) {
		switch rawValue {
		case "Feature":
			self = .feature
		case "FeatureCollection":
			self = .featureCollection
		default:
			if let geometry = Geometry(rawValue: rawValue) {
				self = .geometry(geometry)
			} else {
				return nil
			}
		}
	}
	
}
