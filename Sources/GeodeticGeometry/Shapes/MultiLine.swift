//
//  MultiLine.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 14/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import Geodesy
import NonEmpty

// MARK: - Protocol

public protocol MultiLineProtocol<CRS>: GeodeticGeometry.MultiPointProtocol
where Points == AtLeast2<[Self.Point]> {
	typealias Line = GeodeticGeometry.Line<CRS>
	associatedtype Lines: NonEmptyProtocol
	where Self.Lines.Element == Self.Line

	var lines: Self.Lines { get set }

	init(lines: Self.Lines)
}

// MARK: - Implementation

public struct MultiLine<CRS>: GeodeticGeometry.MultiLineProtocol
where CRS: Geodesy.CoordinateReferenceSystem {
	public typealias Line = GeodeticGeometry.Line<CRS>
	public typealias Lines = NonEmpty<[Self.Line]>

	public var lines: Self.Lines

	public init(lines: Self.Lines) {
		self.lines = lines
	}
	public init(points: Self.Points) {
		let lines: [Self.Line] = points.adjacentPairs().map(Self.Line.init(start:end:))
		self.init(lines: try! Self.Lines(lines))
	}
}

public extension MultiLineProtocol {
	var points: Self.Points {
		Points(
			lines.first.points.first,
			lines.first.points.second,
			tail: lines.dropFirst(Lines.minimumCount).flatMap(\.points)
		)
	}
}
