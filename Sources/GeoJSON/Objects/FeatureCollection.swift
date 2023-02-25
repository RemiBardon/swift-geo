//
//  FeatureCollection.swift
//  GeoSwift
//
//  Created by Rémi Bardon on 07/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

/// A [GeoJSON FeatureCollection](https://datatracker.ietf.org/doc/html/rfc7946#section-3.3).
public struct FeatureCollection<
	ID: Codable,
	Geometry: GeoJSON.Geometry & Codable,
	Properties: Codable
>: CodableObject {
	
	public static var geoJSONType: GeoJSON.`Type` { .featureCollection }
	
	public var features: [Feature<ID, Geometry, Properties>]
	
	public var bbox: AnyBoundingBox? {
		features.compactMap(\.bbox).reduce(nil, { $0.union($1.asAny) })
	}
	
}

extension FeatureCollection: Equatable where ID: Equatable, Properties: Equatable {
	
	public static func == (lhs: Self, rhs: Self) -> Bool {
		return lhs.features == rhs.features
	}
	
}

extension FeatureCollection: Hashable where ID: Hashable, Properties: Hashable {
	
	public func hash(into hasher: inout Hasher) {
		hasher.combine(features)
	}
	
}

/// A (half) type-erased ``FeatureCollection``.
public typealias AnyFeatureCollection<
	Properties: Codable
> = FeatureCollection<NonID, AnyGeometry, Properties>
