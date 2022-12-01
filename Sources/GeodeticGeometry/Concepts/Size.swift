//
//  Size.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 28/11/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import Geodesy

public typealias Size = Vector

public extension Size where RawValue: AtLeastTwoDimensionalCoordinates {
	/// - Warning: In a geographic CRS, ``Vector2D/width`` represents the vertical length,
	///   because ``Vector2D/DX`` represents the latitude (vertical axis).
	///   You can use ``Vector2D/horizontalDelta`` to remove ambiguity.
	var width: RawValue.X { self.dx }
	/// - Warning: In a geographic CRS, ``Vector2D/height`` represents the horizontal length,
	///   because ``Vector2D/DY`` represents the longitude (horizontal axis).
	///   You can use ``Vector2D/horizontalDelta`` to remove ambiguity.
	var height: RawValue.Y { self.dy }
}

public extension Size where RawValue: AtLeastThreeDimensionalCoordinates {
	var zHeight: RawValue.Z { self.dz }
}
