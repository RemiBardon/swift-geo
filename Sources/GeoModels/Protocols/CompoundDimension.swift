//
//  CompoundDimension.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 26/03/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

@dynamicMemberLookup
public protocol CompoundDimension {
	
	associatedtype LowerDimension
	
	var lowerDimension: LowerDimension { get }
	
}

extension CompoundDimension {
	
	public subscript<T>(dynamicMember keyPath: KeyPath<Self.LowerDimension, T>) -> T {
		self.lowerDimension[keyPath: keyPath]
	}
	
}
