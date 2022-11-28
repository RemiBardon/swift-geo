//
//  File.swift
//  
//
//  Created by Rémi Bardon on 28/11/2022.
//

import GeodeticGeometry

public extension MultiPoint {
	func makeIterator() -> NonEmptyIterator<Self.Points> {
		NonEmptyIterator(base: self.points)
	}
}
