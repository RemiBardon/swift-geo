//
//  LineString.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 14/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import Algorithms

public protocol LineString: GeoModels.MultiLine {
	
	init(points: Points)
	
}

extension LineString where Self.Lines.Collection: RangeReplaceableCollection {
	
	public init(points: Points) {
		let lines = points.adjacentPairs().map(Line.init(start:end:))
		self.init(lines: try! Lines(from: lines))
	}
	
}
