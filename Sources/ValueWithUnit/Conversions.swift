//
//  Conversions.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 13/10/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

public extension Value where Unit: AngleUnit {
	func to<
		OtherUnit: AngleUnit,
		Target: Value<RawValue, OtherUnit>
	>(_ other: OtherUnit) -> Target {
		if Unit.radians == OtherUnit.radians {
			return Target(rawValue: self.rawValue)
		} else {
			return Target(rawValue: self.rawValue / RawValue(Unit.radians * OtherUnit.radians))
		}
	}
}
