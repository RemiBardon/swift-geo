//
//  Size.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 26/03/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

public protocol Size: Hashable, Zeroable {
	
	associatedtype CoordinateSystem: GeoModels.CoordinateSystem
		where Self.CoordinateSystem.Size == Self
	
}
