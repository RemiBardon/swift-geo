//
//  BoundingBox.swift
//  GeoSwift
//
//  Created by Rémi Bardon on 04/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import GeoModels

/// A [GeoJSON Bounding Box](https://datatracker.ietf.org/doc/html/rfc7946#section-5).
public protocol BoundingBox: GeoModels.BoundingBox, Codable {
	
	/// This bonding box, but type-erased.
	var asAny: AnyBoundingBox { get }
	
}

/// A two-dimensional ``BoundingBox``.
public typealias BoundingBox2D = GeoModels.BoundingBox2D

extension BoundingBox2D: BoundingBox {
	
	public var asAny: AnyBoundingBox { .twoDimensions(self) }
	
}

/// A three-dimensional ``BoundingBox``.
public typealias BoundingBox3D = GeoModels.BoundingBox3D

extension BoundingBox3D: BoundingBox {
	
	public var asAny: AnyBoundingBox { .threeDimensions(self) }
	
}

/// A type-erased ``BoundingBox``.
public enum AnyBoundingBox: BoundingBox, Hashable, Codable {
	
	public static var zero: AnyBoundingBox = .twoDimensions(.zero)
	
	public func union(_ other: AnyBoundingBox) -> AnyBoundingBox {
		switch (self, other) {
		case let (.twoDimensions(self), .twoDimensions(other)):
			return .twoDimensions(self.union(other))
			
		case let (.twoDimensions(bbox2d), .threeDimensions(bbox3d)),
			 let (.threeDimensions(bbox3d), .twoDimensions(bbox2d)):
			return .threeDimensions(bbox3d.union(bbox2d))
			
		case let (.threeDimensions(self), .threeDimensions(other)):
			return .threeDimensions(self.union(other))
		}
	}
	
	case twoDimensions(BoundingBox2D)
	case threeDimensions(BoundingBox3D)
	
	public var asAny: AnyBoundingBox { self }
	
}
