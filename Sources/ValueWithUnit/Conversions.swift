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
		Target: Value<OtherUnit>
	>(_ other: OtherUnit) -> Target where Target.RawValue == Self.RawValue {
		if Unit.radiansFactor == OtherUnit.radiansFactor {
			return Target(rawValue: self.rawValue)
		} else {
			let factor = RawValue(OtherUnit.radiansFactor / Unit.radiansFactor)
			return Target(rawValue: self.rawValue * factor)
		}
	}
}
