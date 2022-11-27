//
//  LinearRing.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 17/03/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import Algorithms
import NonEmpty

public protocol LinearRing<GeometricSystem>: GeodeticGeometry.LineString {}

extension LinearRing where Self.Lines.Collection: RangeReplaceableCollection {
	
	public init(points: Points) {
		let pairs: [(Point, Point)]
		if points.last != points.first {
			pairs = points.adjacentPairs() + [(points.last, points.first)]
		} else {
			pairs = Array(points.adjacentPairs())
		}
		let lines = pairs.map(Line.init(start:end:))
		self.init(lines: try! Lines(from: lines))
	}
	
}
