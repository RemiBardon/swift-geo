//
//  BoundingBoxCache.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 10/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import GeoModels

public class BoundingBoxCache {
	
	public static let shared = BoundingBoxCache()
	
	private var values = [AnyHashable: Any]()
	
	private init() {}
	
	internal func store<B: BoundingBox, K: Hashable>(_ value: B, forKey key: K) {
		values[AnyHashable(key)] = value
	}
	
	internal func get<B: BoundingBox, K: Hashable>(_ type: B.Type, forKey key: K) -> B? {
		values[AnyHashable(key)] as? B
	}
	
	public func bbox<B: Boundable & Hashable>(for boundable: B) -> B.BoundingBox {
		if let cachedValue = self.get(B.BoundingBox.self, forKey: boundable) {
			return cachedValue
		} else {
			let bbox = boundable._bbox
			self.store(bbox, forKey: boundable)
			return bbox
		}
	}
	
	public func removeCache<K: Hashable>(for key: K) {
		values.removeValue(forKey: AnyHashable(key))
	}
	
}
