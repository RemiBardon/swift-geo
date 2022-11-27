//
//  WGS84+Turf.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 20/03/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import enum WGS84Geometry.WGS842D
import enum WGS84Geometry.WGS843D
import protocol Turf.GeometricSystemAlgebra

extension WGS842D: GeometricSystemAlgebra {}
extension WGS843D: GeometricSystemAlgebra {}
