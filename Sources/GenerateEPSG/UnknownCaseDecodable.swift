//
//  UnknownCaseDecodable.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 07/12/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

/// Comes from [OMG a new enum case!](https://link.medium.com/PhETT8BKg9)
public protocol UnknownCaseDecodable: Decodable, RawRepresentable
where RawValue: Equatable & Codable
{
	static var knownCases: [Self] { get }
	var isUnknownCase: Bool { get }
	static func unknownCase(_ rawValue: RawValue) -> Self
}

public extension UnknownCaseDecodable {
	init(rawValue: RawValue) {
		let value = Self.knownCases.first { $0.rawValue == rawValue }
		self = value ?? Self.unknownCase(rawValue)
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		let rawValue = try container.decode(RawValue.self)
		self = Self(rawValue: rawValue)
	}
}
