//
//  FloatingPoint+Fraction.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 24/08/2021.
//  Copyright © 2021 Rémi Bardon. All rights reserved.
//

public extension FloatingPoint {
	var swiftgeo_whole: Self { self.rounded(.towardZero) }
	var swiftgeo_fraction: Self { self - self.swiftgeo_whole }
}
