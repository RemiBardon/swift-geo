//
//  Position.swift
//  GeoSwift
//
//  Created by Rémi Bardon on 04/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import GeoModels
import Turf

/// A [GeoJSON Position](https://datatracker.ietf.org/doc/html/rfc7946#section-3.1.1).
public protocol Position: Boundable {}

/// A ``Position`` with two elements (longitude and latitude).
public typealias Position2D = Coordinate2D

extension Position2D: Position {}

/// A ``Position`` with three elements (longitude, latitude and altitude).
public typealias Position3D = Coordinate3D

extension Position3D: Position {}
