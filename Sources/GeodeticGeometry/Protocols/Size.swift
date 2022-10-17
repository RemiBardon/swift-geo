//
//  Size.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 26/03/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import Geodesy

public protocol Size<CRS>: Hashable, RawRepresentable, Zeroable {

	associatedtype CRS: Geodesy.CoordinateReferenceSystem

	init(rawValue: RawValue)

}

public extension Size where RawValue: Zeroable {

	static var zero: Self { Self.init(rawValue: .zero) }

}
