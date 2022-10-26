//
//  InitializableByNumber.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 25/10/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

/// `BinaryInteger` and `BinaryFloatingPoint` declare initializers
/// for converting between numeric representations.
/// However, there can be types (e.g. `(Double, Double)`) which we'd like to instanciate
/// with a single value (e.g. `.init(3) = (3, 3)`), but they would not be able to implement
/// requirements like `exponentBitPattern` for `BinaryFloatingPoint`s.
public typealias InitializableByNumber = InitializableByInteger & InitializableByFloatingPoint

public protocol InitializableByInteger {
	init<Source: BinaryInteger>(_ value: Source)
}
public protocol InitializableByFloatingPoint {
	init<Source: BinaryFloatingPoint>(_ value: Source)
}

// MARK: Extensions for standard `BinaryInteger`s

extension Int: InitializableByNumber {}
extension Int8: InitializableByNumber {}
extension Int16: InitializableByNumber {}
extension Int32: InitializableByNumber {}
extension Int64: InitializableByNumber {}
extension UInt: InitializableByNumber {}
extension UInt8: InitializableByNumber {}
extension UInt16: InitializableByNumber {}
extension UInt32: InitializableByNumber {}
extension UInt64: InitializableByNumber {}

// MARK: Extensions for standard `BinaryFloatingPoint`s

extension Double: InitializableByNumber {}
extension Float: InitializableByNumber {}
