//
//  Object.swift
//  GeoSwift
//
//  Created by Rémi Bardon on 04/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

public protocol Object {
	
	associatedtype BoundingBox: GeoJSON.BoundingBox
	
	static var geoJSONType: GeoJSON.`Type` { get }
	
	var bbox: BoundingBox? { get }
	
}
