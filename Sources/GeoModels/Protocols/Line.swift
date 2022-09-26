//
//  Line.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 14/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import NonEmpty

public protocol Line<CoordinateSystem>: GeoModels.MultiPoint
where Self.Points == AtLeast2<[Self.Point]>
{
	
	var start: Self.Point { get }
	var end: Self.Point { get }
	
	init(start: Self.Point, end: Self.Point)
	
}

extension Line {
	
	public init(from: Self.Point, to: Self.Point) {
		self.init(start: from, end: to)
	}

	public var vector: Self {
		return Self(start: .zero, end: self.end - self.start)
	}
	
}

// MARK: GeoModels.MultiPoint

extension Line {
	
	public var points: Self.Points { Self.Points(start, end) }
	
	public init(points: Self.Points) {
		assert(Self.Points.minimumCount == 2, "`Points` has a `minimumCount` of \(Self.Points.minimumCount) instead of 2. This is a bug, and you should report it.")
		assert(!points.dropFirst(2).isEmpty, "`points` contains \(points.count) elements, while it should contain exactly 2 elements.")
		self.init(start: points.first, end: points.second)
	}
	
}
