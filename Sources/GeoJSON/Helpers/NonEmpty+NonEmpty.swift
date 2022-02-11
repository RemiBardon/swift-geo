//
//  NonEmpty+NonEmpty.swift
//  GeoSwift
//
//  Created by Rémi Bardon on 07/02/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import NonEmpty

extension NonEmpty {
	
	/// `NonEmpty.init(rawValue:): 	(C) -> NonEmpty<C>?`
	/// `I need: 					(C) -> NonEmpty<NonEmpty<C>>?`
	
	static func case2<C: Swift.Collection>(_ collection: C) -> NonEmpty<NonEmpty<C>>? {
		if let collection: NonEmpty<C> = NonEmpty<C>(rawValue: collection) {
			return NonEmpty<NonEmpty<C>>(rawValue: collection)
		} else {
			return nil
		}
	}
	
	init?<C: Swift.Collection>(nested rawValue: C) where Collection == NonEmpty<C> {
		if let collection: NonEmpty<C> = NonEmpty<C>(rawValue: rawValue) {
			self.init(rawValue: collection)
		} else {
			return nil
		}
	}
	
	init?<C: Swift.Collection>(nestedCollection rawValue: C) where Collection == NonEmpty<NonEmpty<C>> {
		guard let a = NonEmpty<C>(rawValue: rawValue) else { return nil }
		guard let b = NonEmpty<NonEmpty<C>>(rawValue: a) else { return nil }
		
		self.init(rawValue: b)
	}
	
}
