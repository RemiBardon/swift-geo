//
//  AdditiveArithmetic+Ext.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 26/10/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

public extension AdditiveArithmetic where Self: InitializableByInteger {
	static func + <N: BinaryInteger>(lhs: Self, rhs: N) -> Self {
		lhs + Self.init(rhs)
	}
	static func + <N: BinaryInteger>(lhs: N, rhs: Self) -> Self {
		Self.init(lhs) + rhs
	}
	static func - <N: BinaryInteger>(lhs: Self, rhs: N) -> Self {
		lhs - Self.init(rhs)
	}
	static func - <N: BinaryInteger>(lhs: N, rhs: Self) -> Self {
		Self.init(lhs) - rhs
	}
}

public extension AdditiveArithmetic where Self: InitializableByFloatingPoint {
	static func + <N: BinaryFloatingPoint>(lhs: Self, rhs: N) -> Self {
		lhs + Self.init(rhs)
	}
	static func + <N: BinaryFloatingPoint>(lhs: N, rhs: Self) -> Self {
		Self.init(lhs) + rhs
	}
	static func - <N: BinaryFloatingPoint>(lhs: Self, rhs: N) -> Self {
		lhs - Self.init(rhs)
	}
	static func - <N: BinaryFloatingPoint>(lhs: N, rhs: Self) -> Self {
		Self.init(lhs) - rhs
	}
}

public extension AdditiveArithmetic
where Self: SafeRawRepresentable,
			RawValue: AdditiveArithmetic & InitializableByInteger
{
	static func + <N: BinaryInteger>(lhs: Self, rhs: N) -> Self {
		lhs + Self.init(rawValue: RawValue(rhs))
	}
	static func + <N: BinaryInteger>(lhs: N, rhs: Self) -> Self {
		Self.init(rawValue: RawValue(lhs)) + rhs
	}
	static func - <N: BinaryInteger>(lhs: Self, rhs: N) -> Self {
		lhs - Self.init(rawValue: RawValue(rhs))
	}
	static func - <N: BinaryInteger>(lhs: N, rhs: Self) -> Self {
		Self.init(rawValue: RawValue(lhs)) - rhs
	}
}

public extension AdditiveArithmetic
where Self: SafeRawRepresentable,
			RawValue: AdditiveArithmetic & InitializableByFloatingPoint
{
	static func + <N: BinaryFloatingPoint>(lhs: Self, rhs: N) -> Self {
		Self.init(rawValue: lhs.rawValue + rhs)
	}
	static func + <N: BinaryFloatingPoint>(lhs: N, rhs: Self) -> Self {
		Self.init(rawValue: RawValue(lhs)) + rhs
	}
	static func - <N: BinaryFloatingPoint>(lhs: Self, rhs: N) -> Self {
		lhs - Self.init(rawValue: RawValue(rhs))
	}
	static func - <N: BinaryFloatingPoint>(lhs: N, rhs: Self) -> Self {
		Self.init(rawValue: RawValue(lhs)) - rhs
	}
}
