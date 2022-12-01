//
//  Line.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 14/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import Geodesy
import NonEmpty

// MARK: - Protocol

public struct Line<CRS: Geodesy.CoordinateReferenceSystem>: Hashable {
	public typealias Point = GeodeticGeometry.Point<CRS>
	public typealias Points = AtLeast2<[Self.Point]>
	
	public var start: Self.Point
	public var end: Self.Point

	public var vector: Vector<CRS> { Vector(from: start, to: end) }

	public init(start: Self.Point, end: Self.Point) {
		self.start = start
		self.end = end
	}
	public init(from: Self.Point, to: Self.Point) {
		self.init(start: from, end: to)
	}
	public init(from: Self.Point.Coordinates, to: Self.Point.Coordinates) {
		self.init(start: .init(coordinates: from), end: .init(coordinates: to))
	}
}

// MARK: - Implementation

extension Line: GeodeticGeometry.MultiPointProtocol {
	
	public var points: Self.Points { Self.Points(start, end) }
	
	public init(points: Self.Points) {
		assert(Self.Points.minimumCount == 2, "`Points` has a `minimumCount` of \(Self.Points.minimumCount) instead of 2. This is a bug, and you should report it.")
		assert(!points.dropFirst(2).isEmpty, "`points` contains \(points.count) elements, while it should contain exactly 2 elements.")
		self.init(start: points.first, end: points.second)
	}
	
}
