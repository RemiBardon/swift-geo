//
//  Coordinates.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 02/07/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

public protocol Coordinates: Hashable, Zeroable, AdditiveArithmetic {

	init<N: BinaryFloatingPoint>(repeating number: N)
	init<N: BinaryInteger>(repeating number: N)

	static func / (lhs: Self, rhs: Self) -> Self

}

extension Coordinates {

	public static func / <N: BinaryFloatingPoint>(lhs: Self, rhs: N) -> Self {
		lhs / Self(repeating: rhs)
	}

	public static func / <N: BinaryInteger>(lhs: Self, rhs: N) -> Self {
		lhs / Self(repeating: rhs)
	}

}
