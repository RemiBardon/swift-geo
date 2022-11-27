//
//  MultiplicativeArithmetic.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 24/10/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

public protocol MultiplicativeArithmetic {
	static func * (lhs: Self, rhs: Self) -> Self
	static func / (lhs: Self, rhs: Self) -> Self
}

public extension MultiplicativeArithmetic where Self: InitializableByInteger {
	static func * <N: BinaryInteger>(lhs: Self, rhs: N) -> Self {
		lhs * Self.init(rhs)
	}
	static func * <N: BinaryInteger>(lhs: N, rhs: Self) -> Self {
		Self.init(lhs) * rhs
	}
	static func / <N: BinaryInteger>(lhs: Self, rhs: N) -> Self {
		lhs / Self.init(rhs)
	}
	static func / <N: BinaryInteger>(lhs: N, rhs: Self) -> Self {
		Self.init(lhs) / rhs
	}
}

public extension MultiplicativeArithmetic where Self: InitializableByFloatingPoint {
	static func * <N: BinaryFloatingPoint>(lhs: Self, rhs: N) -> Self {
		lhs * Self.init(rhs)
	}
	static func * <N: BinaryFloatingPoint>(lhs: N, rhs: Self) -> Self {
		Self.init(lhs) * rhs
	}
	static func / <N: BinaryFloatingPoint>(lhs: Self, rhs: N) -> Self {
		lhs / Self.init(rhs)
	}
	static func / <N: BinaryFloatingPoint>(lhs: N, rhs: Self) -> Self {
		Self.init(lhs) / rhs
	}
}

public extension MultiplicativeArithmetic
where Self: SafeRawRepresentable,
			RawValue: MultiplicativeArithmetic & InitializableByInteger
{
	@_disfavoredOverload
	static func * <N: BinaryInteger>(lhs: Self, rhs: N) -> Self {
		lhs * Self.init(rawValue: .init(rhs))
	}
	@_disfavoredOverload
	static func * <N: BinaryInteger>(lhs: N, rhs: Self) -> Self {
		Self.init(rawValue: .init(lhs)) * rhs
	}
	@_disfavoredOverload
	static func / <N: BinaryInteger>(lhs: Self, rhs: N) -> Self {
		lhs / Self.init(rawValue: .init(rhs))
	}
	@_disfavoredOverload
	static func / <N: BinaryInteger>(lhs: N, rhs: Self) -> Self {
		Self.init(rawValue: .init(lhs)) / rhs
	}
}

public extension MultiplicativeArithmetic
where Self: SafeRawRepresentable,
			RawValue: MultiplicativeArithmetic & InitializableByFloatingPoint
{
	@_disfavoredOverload
	static func * <N: BinaryFloatingPoint>(lhs: Self, rhs: N) -> Self {
		Self.init(rawValue: lhs.rawValue * rhs)
	}
	@_disfavoredOverload
	static func * <N: BinaryFloatingPoint>(lhs: N, rhs: Self) -> Self {
		Self.init(rawValue: .init(lhs)) * rhs
	}
	@_disfavoredOverload
	static func / <N: BinaryFloatingPoint>(lhs: Self, rhs: N) -> Self {
		lhs / Self.init(rawValue: .init(rhs))
	}
	@_disfavoredOverload
	static func / <N: BinaryFloatingPoint>(lhs: N, rhs: Self) -> Self {
		Self.init(rawValue: .init(lhs)) / rhs
	}
}
