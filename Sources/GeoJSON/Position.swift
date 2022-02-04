//
//  Position.swift
//  GeoSwift
//
//  Created by Rémi Bardon on 04/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import GeoModels
import Turf

public protocol Position: Hashable, Boundable {}

public typealias Position2D = Coordinate2D

extension Position2D: Position {}
