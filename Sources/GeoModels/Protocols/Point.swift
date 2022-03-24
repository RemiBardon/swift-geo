//
//  Point.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 06/03/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import NonEmpty

public protocol Point: Hashable, Zeroable {
	
	associatedtype CoordinateSystem: GeoModels.CoordinateSystem
		where Self.CoordinateSystem.Point == Self
	associatedtype Components
	
	var components: Components { get }
	
	init(_ components: Components)
	
}
