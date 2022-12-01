//
//  MultiPoint.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 14/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import Geodesy
import NonEmpty

// MARK: - Protocol

public protocol MultiPointProtocol<CRS>: Hashable {
	associatedtype CRS: Geodesy.CoordinateReferenceSystem
	typealias Point = GeodeticGeometry.Point<CRS>
	associatedtype Points: NonEmptyProtocol
	where Self.Points.Element == Self.Point

	var points: Self.Points { get }

	init(points: Self.Points)
}

// MARK: - Implementation

public struct MultiPoint<CRS>: MultiPointProtocol
where CRS: Geodesy.CoordinateReferenceSystem {
	public typealias Point = GeodeticGeometry.Point<CRS>
	public typealias Points = NonEmpty<[Self.Point]>

	public var points: Self.Points

	public init(points: Self.Points) {
		self.points = points
	}
	public init(coordinates: NonEmpty<[Self.Point.Coordinates]>) {
		let points: [Self.Point] = coordinates.map(Self.Point.init(coordinates:))
		self.init(points: try! Self.Points(points))
	}
}
