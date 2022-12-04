//
//  Iterable.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 28/11/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import NonEmpty

public protocol Iterable<Element> {
	associatedtype Element
	associatedtype Iterator: IteratorProtocol<Element>
	func makeIterator() -> Iterator
}

public protocol NonEmptyIterable<Base>: Iterable
where Iterator == NonEmptyIterator<Base>
{
	associatedtype Base: NonEmptyProtocol
}

public struct NonEmptyIterator<Base: NonEmptyProtocol>: IteratorProtocol {
	public typealias Element = Base.Element

	private let _first: Element
	private var base: Base.Iterator
	private var firstElementAccessed: Bool = false

	public init(base: Base) {
		self._first = base.first
		self.base = base.makeIterator()
	}

	public mutating func first() -> Element {
		if self.firstElementAccessed {
			return self._first
		} else {
			// Skip first element in iterator
			_ = self.base.next()
			self.firstElementAccessed = true
			return self._first
		}
	}
	public mutating func next() -> Element? {
		self.base.next()
	}
}

// MARK: - Standard types conformances

extension Array: Iterable {}
extension Set: Iterable {}
extension Slice: Iterable {}

// MARK: - Third-party type conformances

extension NonEmpty: Iterable {}
