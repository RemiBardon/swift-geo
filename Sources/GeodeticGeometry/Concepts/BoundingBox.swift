//
//  BoundingBox.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 04/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import Geodesy
import SwiftGeoToolbox

public struct BoundingBox<CRS: Geodesy.CoordinateReferenceSystem> {
	public typealias Coordinates = CRS.Coordinates
	public typealias Size = GeodeticGeometry.Size<CRS>

	public var origin: Self.Coordinates
	public var size: Self.Size

	public var center: Self.Coordinates {
		self.origin + self.size / 2
	}

	public init(origin: Self.Coordinates, size: Self.Size) {
		self.origin = origin
		self.size = size
	}
	public init(min: Self.Coordinates, max: Self.Coordinates) {
		self.init(origin: min, size: .init(from: min, to: max))
	}

	#warning("TODO: Reimplement `BoundingBox.union(_ other: Self)`")
	/// The union of bounding boxes gives a new bounding box that encloses the given two.
//	public func union(_ other: Self) -> Self
}

extension BoundingBox: Hashable {}

extension BoundingBox: Zeroable {
	public static var zero: Self { Self.init(origin: .zero, size: .zero) }
}
