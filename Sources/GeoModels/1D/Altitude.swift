//
//  Altitude.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 08/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

public struct Altitude: Coordinate {
	
	public var meters: Double
	
	public init(meters: Double) {
		self.meters = meters
	}
	
}

extension Altitude {
	
	public var value: Double {
		get { meters }
		set { meters = newValue }
	}
	
	public init(value: Double) {
		self.init(meters: value)
	}
	
	public static func random() -> Self {
		return Self.random(in: -100...10_000)
	}
	
}
