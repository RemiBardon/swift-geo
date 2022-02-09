//
//  Object.swift
//  GeoSwift
//
//  Created by Rémi Bardon on 04/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

/// A [GeoJSON Object](https://datatracker.ietf.org/doc/html/rfc7946#section-3).
public protocol Object: Hashable, Codable {
	
	associatedtype BoundingBox: GeoJSON.BoundingBox
	
	/// The [GeoJSON type](https://datatracker.ietf.org/doc/html/rfc7946#section-1.4) of this
	/// [GeoJSON object](https://datatracker.ietf.org/doc/html/rfc7946#section-3).
	static var geoJSONType: GeoJSON.`Type` { get }
	
	var bbox: BoundingBox? { get }
	
}
