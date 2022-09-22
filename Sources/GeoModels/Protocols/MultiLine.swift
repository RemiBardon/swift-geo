//
//  MultiLine.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 14/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import NonEmpty

public protocol MultiLine: GeoModels.MultiPoint
where Points == AtLeast2<[Self.Point]>
{

	typealias Line = Self.CoordinateSystem.Line
	associatedtype Lines: NonEmptyProtocol
	where Self.Lines.Element == Self.Line

	var lines: Self.Lines { get }

	init(lines: Self.Lines)

}

extension MultiLine {

	public var points: Self.Points {
		Points(
			lines.first.points.first,
			lines.first.points.second,
			tail: lines.dropFirst(Lines.minimumCount).flatMap(\.points)
		)
	}
	
}
