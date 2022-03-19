//
//  MultiLine.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 14/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import NonEmpty

public protocol MultiLine: GeoModels.MultiPoint
where Points == AtLeast2<[Point]>
{
	
	associatedtype Line: GeoModels.Line where Line.Point == Point
	associatedtype Lines: NonEmptyProtocol where Lines.Element == Line
	
	var lines: Lines { get }
	
	init(lines: Lines)
	
}

extension MultiLine {
	
	public var points: Points {
		Points(
			lines.head.points.first,
			lines.head.points.second,
			tail: lines.dropFirst(Lines.minimumCount).flatMap(\.points)
		)
	}
	
}
