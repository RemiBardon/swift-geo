//
//  LineString2D.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 11/09/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import GeoCoordinates
import NonEmpty

public struct LineString2D: GeoModels.LineString, Hashable {

	public typealias CoordinateSystem = GeoModels.Geo2D
	public typealias Points = AtLeast2<[Point2D]>
	public typealias Lines = NonEmpty<[Line2D]>

	public internal(set) var points: Points

	public init(points: Points) {
		self.points = points
	}

	public mutating func append(_ point: Self.Point) {
		self.points.append(point)
	}

}
