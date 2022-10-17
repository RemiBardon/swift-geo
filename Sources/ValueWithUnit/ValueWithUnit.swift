//
//  ValueWithUnit.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 13/10/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import Foundation

public protocol Unit: Hashable, Sendable {
	#warning("TODO: Add name")
}
public protocol AngleUnit: Unit {
	static var radians: Double { get }
}
public protocol LengthUnit: Unit {
	static var meters: Double { get }
}

public protocol Value<RawValue, Unit>: RawRepresentable
where RawValue: BinaryFloatingPoint
{
	associatedtype Unit: ValueWithUnit.Unit
	init(rawValue: RawValue)
}

public struct Radian: AngleUnit {
	public static let radians: Double = 1
}
public struct Degree: AngleUnit {
	public static let radians: Double = 180.0 / .pi
}
public struct Meter: LengthUnit {
	public static let meters: Double = 1
}

public struct DoubleOf<U: ValueWithUnit.Unit>: Value, Hashable {
	public typealias Unit = U
	public var rawValue: Double
	public init(rawValue: RawValue) {
		self.rawValue = rawValue
	}
}
