//
//  File.swift
//  
//
//  Created by Rémi Bardon on 10/12/2022.
//

import Stencil

protocol Template {
	static var template: String { get }
	func representation() throws -> String
}

extension Template {
	func representation() throws -> String {
		return try environment.renderTemplate(string: Self.template, context: ["self": self])
	}
}

//struct AxisTemplate: Template {
//	
//}
//
//struct CoordinateSystemTemplate: Template {
//	enum Dimensions: String {
//		case two = "TwoDimensionalCS"
//		case three = "ThreeDimensionalCS"
//	}
//}

struct UnitTemplate: Template {
	static let template: String = """
	public enum EPSG{{ self.epsgCode }}: Geodesy.UnitOfMeasurement {
		public static let epsgName: String = "{{ self.epsgName }}"
		public static let epsgCode: Int = {{ self.epsgCode }}
	}
	"""

	let epsgName: String
	let epsgCode: Int

	init(from dto: UnitOfMeasure) {
		self.epsgName = dto.Name
		self.epsgCode = dto.Code
	}
}
