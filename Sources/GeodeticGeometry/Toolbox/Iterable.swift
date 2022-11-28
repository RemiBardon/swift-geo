//
//  Iterable.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 28/11/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import protocol NonEmpty.NonEmptyProtocol

public protocol Iterable<Element> {
	associatedtype Element
	associatedtype Iterator: IteratorProtocol<Element>
	func makeIterator() -> Iterator
}

public protocol NonEmptyIterable<Base>: Iterable {
	associatedtype Base: NonEmptyProtocol
	func makeIterator() -> NonEmptyIterator<Base>
}

public struct NonEmptyIterator<Base: NonEmptyProtocol>: IteratorProtocol {
	private let _first: Base.Element
	private var base: Base.Iterator
	private var firstElementAccessed: Bool = false

	init(base: Base) {
		self._first = base.first
		self.base = base.makeIterator()
	}

	public mutating func first() -> Base.Element {
		if self.firstElementAccessed {
			return self._first
		} else {
			// Skip first element in iterator
			_ = self.base.next()
			self.firstElementAccessed = true
			return self._first
		}
	}
	public mutating func next() -> Base.Element? {
		self.base.next()
	}
}
