//
//  Errors.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 07/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import Foundation

/// Error when creating ``LinearRingCoordinates``.
///
/// See [RFC 7946, section 3.1.6](https://datatracker.ietf.org/doc/html/rfc7946#section-3.1.6).
public enum LinearRingError: Error {
	case firstAndLastPositionsShouldBeEquivalent
	case notEnoughPoints
}
