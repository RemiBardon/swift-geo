//
//  BoundingBox.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 04/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

public protocol BoundingBox {
	
	static var zero: Self { get }
	
	func union(_ other: Self) -> Self
	
}
