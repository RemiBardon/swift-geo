//
//  DefaultCaseDecodable.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 26/08/2020.
//  Copyright © 2020 Rémi Bardon. All rights reserved.
//

/// Comes from [OMG a new enum case!](https://link.medium.com/PhETT8BKg9)
public protocol DefaultCaseDecodable: Decodable, RawRepresentable, CaseIterable
where RawValue: Equatable & Codable
{
	static var defaultCase: Self { get }
}

public extension DefaultCaseDecodable {
	static var nonDefaultCases: [Self] {
		Self.allCases.filter { $0 != Self.defaultCase }
	}

	init(rawValue: RawValue) {
		let value = Self.allCases.first { $0.rawValue == rawValue }
		self = value ?? Self.defaultCase
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		let rawValue = try container.decode(RawValue.self)
		self = Self(rawValue: rawValue) ?? Self.defaultCase
	}
}
