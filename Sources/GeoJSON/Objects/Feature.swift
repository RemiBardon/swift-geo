//
//  Feature.swift
//  GeoSwift
//
//  Created by Rémi Bardon on 04/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

/// A [GeoJSON Feature](https://datatracker.ietf.org/doc/html/rfc7946#section-3.2).
public struct Feature<
	ID: Codable,
	Geometry: GeoJSON.Geometry & Codable,
	Properties: Codable
>: CodableObject {
	
	public static var geoJSONType: GeoJSON.`Type` { .feature }
	
	public var bbox: Geometry.BoundingBox? { geometry?.bbox }
	
	public var id: ID?
	public var geometry: Geometry?
	/// The `"properties"` field of a [GeoJSON Feature](https://datatracker.ietf.org/doc/html/rfc7946#section-3.2).
	public var properties: Properties
	
	public init(id: ID?, geometry: Geometry?, properties: Properties) {
		self.id = id
		self.geometry = geometry
		self.properties = properties
	}
	
	public init(geometry: Geometry?, properties: Properties) where ID == NonID {
		self.id = nil
		self.geometry = geometry
		self.properties = properties
	}
	
}

extension Feature: Identifiable where ID: Hashable {}
extension Feature: Equatable where ID: Equatable, Properties: Equatable {
	
	public static func == (lhs: Self, rhs: Self) -> Bool {
		return lhs.id == rhs.id
		&& lhs.geometry == rhs.geometry
		&& lhs.properties == rhs.properties
	}
	
}
extension Feature: Hashable where ID: Hashable, Properties: Hashable {
	
	public func hash(into hasher: inout Hasher) {
		hasher.combine(id)
		hasher.combine(geometry)
		hasher.combine(properties)
	}
	
}

/// A (half) type-erased ``Feature``.
public typealias AnyFeature<Properties: Codable> = Feature<NonID, AnyGeometry, Properties>
