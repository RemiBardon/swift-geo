//
//  MultiLine.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 14/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import NonEmpty

public protocol MultiLine<Point>: GeodeticGeometry.MultiPoint
where Points == AtLeast2<[Self.Point]>
{

	associatedtype Line: GeodeticGeometry.Line<Point>
	associatedtype Lines: NonEmptyProtocol
	where Self.Lines.Element == Self.Line

	var lines: Self.Lines { get }

	init(lines: Self.Lines)

}

extension MultiLine {

	public typealias GeometricSystem = Self.Point.GeometricSystem

	public var points: Self.Points {
		Points(
			lines.first.points.first,
			lines.first.points.second,
			tail: lines.dropFirst(Lines.minimumCount).flatMap(\.points)
		)
	}
	
}
