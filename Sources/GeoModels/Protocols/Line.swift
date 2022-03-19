//
//  Line.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 14/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import NonEmpty

public protocol Line: GeoModels.MultiPoint
where Points == AtLeast2<[Point]>
{
	
	var start: Point { get }
	var end: Point { get }
	
	init(start: Point, end: Point)
	
}

extension Line {
	
	public init(from: Point, to: Point) {
		self.init(start: from, end: to)
	}
	
}

// MARK: GeoModels.MultiPoint

extension Line {
	
	public var points: Points { Points(start, end) }
	
	public init(points: Points) {
		assert(Points.minimumCount == 2, "`Points` has a `minimumCount` of \(Points.minimumCount) instead of 2. This is a bug, and you should report it.")
		assert(!points.dropFirst(2).isEmpty, "`points` contains \(points.count) elements, while it should contain exactly 2 elements.")
		self.init(start: points.first, end: points.second)
	}
	
}
