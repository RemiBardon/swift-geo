//
//  BoundingBox.swift
//  GeoSwift
//
//  Created by Rémi Bardon on 04/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import GeoModels

public protocol BoundingBox: Hashable, Codable {
	
	var asAny: AnyBoundingBox { get }
	
}

public typealias BoundingBox2D = GeoModels.BoundingBox2D

extension BoundingBox2D: BoundingBox {
	
	public var asAny: AnyBoundingBox { .twoDimensions(self) }
	
}

public typealias BoundingBox3D = GeoModels.BoundingBox3D

extension BoundingBox3D: BoundingBox {
	
	public var asAny: AnyBoundingBox { .threeDimensions(self) }
	
}

public enum AnyBoundingBox: BoundingBox, Hashable, Codable {
	
	case twoDimensions(BoundingBox2D)
	case threeDimensions(BoundingBox3D)
	
	public var asAny: AnyBoundingBox { self }
	
}
