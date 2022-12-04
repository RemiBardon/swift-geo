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
}

extension BoundingBox: Hashable {}

extension BoundingBox: Zeroable {
	public static var zero: Self { Self.init(origin: .zero, size: .zero) }
}

extension BoundingBox: CustomStringConvertible {
	public var description: String {
		"(origin: \(String(describing: self.origin)), size: \(String(describing: self.size)))"
	}
}
extension BoundingBox: CustomDebugStringConvertible {
	public var debugDescription: String {
		"<BBox | \(CRS.epsgName)>(origin: \(String(describing: self.origin)), size: \(String(describing: self.size)))"
	}
}

public extension BoundingBox
where Self.Coordinates: TwoDimensionalCoordinates,
			Self.Coordinates.X == Geodesy.Latitude
{
	var southLatitude: Latitude { origin.latitude }
	var northLatitude: Latitude { southLatitude + size.dLat }
	var centerLatitude: Latitude { southLatitude + (size.dLat / 2) }
}

public extension BoundingBox
where Self.Coordinates: TwoDimensionalCoordinates,
			Self.Coordinates.Y == Geodesy.Longitude
{
	var westLongitude: Longitude { origin.longitude }
	var eastLongitude: Longitude { westLongitude + size.dLong }
	var centerLongitude: Longitude { westLongitude + (size.dLong / 2) }

	var crosses180thMeridian: Bool { !eastLongitude.isValid }
}
