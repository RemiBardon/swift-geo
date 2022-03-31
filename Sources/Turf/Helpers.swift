//
//  Helpers.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 29/03/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import Foundation

extension Sequence where Element: AdditiveArithmetic {
	func sum() -> Element {
		return reduce(.zero, +)
	}
}

