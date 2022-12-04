//
//  Point.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 06/03/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import Geodesy
import SwiftGeoToolbox

public struct Point<CRS: Geodesy.CoordinateReferenceSystem>: Hashable {
	public typealias Coordinates = CRS.Coordinates

	public var coordinates: Self.Coordinates

	public init(coordinates: Self.Coordinates) {
		self.coordinates = coordinates
	}
}

extension Point: Zeroable {
	public static var zero: Self { Self.init(coordinates: .zero) }
}

extension Point: AdditiveArithmetic {
	public static func + (lhs: Self, rhs: Self) -> Self {
		Self.init(coordinates: lhs.coordinates + rhs.coordinates)
	}
	public static func - (lhs: Self, rhs: Self) -> Self {
		Self.init(coordinates: lhs.coordinates - rhs.coordinates)
	}
}

extension Point: MultiplicativeArithmetic {
	public static func * (lhs: Self, rhs: Self) -> Self {
		Self.init(coordinates: lhs.coordinates * rhs.coordinates)
	}
	public static func / (lhs: Self, rhs: Self) -> Self {
		Self.init(coordinates: lhs.coordinates / rhs.coordinates)
	}
}

extension Point: CustomStringConvertible {
	public var description: String {
		String(describing: self.coordinates)
	}
}
extension Point: CustomDebugStringConvertible {
	public var debugDescription: String {
		"<Point | \(CRS.epsgName)>\(String(describing: self.coordinates))"
	}
}

extension Point
where Coordinates: TwoDimensionalCoordinates,
			Coordinates.Y == Geodesy.Longitude
{
	var withPositiveLongitude: Self {
		Self.init(coordinates: self.coordinates.withPositiveLongitude)
	}
}
extension Point
where Coordinates: ThreeDimensionalCoordinates,
			Coordinates.Y == Geodesy.Longitude
{
	var withPositiveLongitude: Self {
		Self.init(coordinates: self.coordinates.withPositiveLongitude)
	}
}
