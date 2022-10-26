//
//  SafeRawRepresentable.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 25/10/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

public protocol SafeRawRepresentable: RawRepresentable {
	init(rawValue: RawValue)
}

public extension SafeRawRepresentable {
	@available(*, unavailable)
	init?(rawValue: RawValue) {
		self.init(rawValue: rawValue)
	}
}
