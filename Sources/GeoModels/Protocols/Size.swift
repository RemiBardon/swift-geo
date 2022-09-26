//
//  Size.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 26/03/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import GeoCoordinates

public protocol Size<CoordinateSystem>: Hashable, RawRepresentable, Zeroable {

	associatedtype CoordinateSystem: GeoModels.CoordinateSystem

	init(rawValue: RawValue)

}

public extension Size where RawValue: Zeroable {

	static var zero: Self { Self.init(rawValue: .zero) }

}
