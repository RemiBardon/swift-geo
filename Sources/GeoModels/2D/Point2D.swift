//
//  Point2D.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 06/03/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

public typealias Point2D = Coordinate2D

extension Point2D: Point {}

extension Point2D: CustomDebugStringConvertible {
	
	public var debugDescription: String { self.ddNotation }
	
}
