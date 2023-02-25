//
//  GeoJSON+Boundable.swift
//  GeoSwift
//
//  Created by Rémi Bardon on 05/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import NonEmpty
import Turf

extension NonEmpty: Boundable where Collection: Hashable, Element: Boundable {
	
	public var _bbox: Element.BoundingBox {
		self.reduce(nil, { $0.union($1.bbox) }) ?? .zero
	}
	
}
