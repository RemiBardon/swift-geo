//
//  Zeroable.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 20/03/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

public protocol Zeroable {
	
	static var zero: Self { get }
	
}

extension BoundingBox where Point: Zeroable {
	
	static var zero: Self { Self.init(origin: Point.zero.components, size: Point.zero.components) }
	
}
