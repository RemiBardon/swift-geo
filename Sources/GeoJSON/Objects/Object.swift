//
//  Object.swift
//  GeoSwift
//
//  Created by Rémi Bardon on 04/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

/// A [GeoJSON Object](https://datatracker.ietf.org/doc/html/rfc7946#section-3).
public protocol Object {
	
	associatedtype BoundingBox: GeoJSON.BoundingBox
	
	var bbox: BoundingBox? { get }
	
}

public protocol CodableObject: GeoJSON.Object, Codable {
	
	/// The [GeoJSON type](https://datatracker.ietf.org/doc/html/rfc7946#section-1.4) of this
	/// [GeoJSON object](https://datatracker.ietf.org/doc/html/rfc7946#section-3).
	static var geoJSONType: GeoJSON.`Type` { get }
	
}
