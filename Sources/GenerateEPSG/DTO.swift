//
//  DTO.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 06/12/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import struct Foundation.URL

// MARK: - /v1/CoordRefSystem

struct SearchResults {
	let results: [SearchResult]
	let count: Int
	let page: Int
	let pageSize: Int
	let totalResults: Int
	let links: [Link]
}
extension SearchResults: Decodable {
	enum CodingKeys: String, CodingKey {
		case results = "Results"
		case count = "Count"
		case page = "Page"
		case pageSize = "PageSize"
		case totalResults = "TotalResults"
		case links = "Links"
	}
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.results = try container.decodeIfPresent([SearchResult].self, forKey: .results) ?? []
		self.count = try container.decode(Int.self, forKey: .count)
		self.page = try container.decode(Int.self, forKey: .page)
		self.pageSize = try container.decode(Int.self, forKey: .pageSize)
		self.totalResults = try container.decode(Int.self, forKey: .totalResults)
		self.links = try container.decodeIfPresent([Link].self, forKey: .links) ?? []
	}
}

struct CRSType: RawRepresentable, Decodable, CustomStringConvertible, CustomDebugStringConvertible {
	static let swiftTypes: [String: String] = [
		"geographic 2D": "TwoDimensionalCRS",
	]
	let rawValue: String
	var isSupported: Bool { Self.swiftTypes.keys.contains(self.rawValue) }
	var swiftType: String { Self.swiftTypes[self.rawValue, default: "CoordinateReferenceSystem"] }
	var description: String { self.swiftType }
	var debugDescription: String { String(reflecting: self.rawValue) }
}

struct SearchResult {
	let code: Int
	let name: String?
	let type: CRSType
	let dataDource: String?
	let area: String?
	let remarks: String?
	let deprecated: Bool
	let superseded: Bool
	let revisionDate: String?
	let links: [Link]
}
extension SearchResult: Decodable {
	enum CodingKeys: String, CodingKey {
		case code = "Code"
		case name = "Name"
		case type = "Type"
		case dataDource = "DataSource"
		case area = "Area"
		case remarks = "Remarks"
		case deprecated = "Deprecated"
		case superseded = "Superseded"
		case revisionDate = "RevisionDate"
		case links = "Links"
	}
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.code = try container.decode(Int.self, forKey: .code)
		self.name = try container.decodeIfPresent(String.self, forKey: .name)
		self.type = try container.decode(CRSType.self, forKey: .type)
		self.dataDource = try container.decodeIfPresent(String.self, forKey: .dataDource)
		self.area = try container.decodeIfPresent(String.self, forKey: .area)
		self.remarks = try container.decodeIfPresent(String.self, forKey: .remarks)
		self.deprecated = try container.decodeIfPresent(Bool.self, forKey: .deprecated) ?? false
		self.superseded = try container.decodeIfPresent(Bool.self, forKey: .superseded) ?? false
		self.revisionDate = try container.decodeIfPresent(String.self, forKey: .revisionDate)
		self.links = try container.decodeIfPresent([Link].self, forKey: .links) ?? []
	}
}

struct Link: Decodable {
	enum CodingKeys: String, CodingKey {
		case rel, href
	}

	let rel: String?
	let href: URL

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.rel = try container.decodeIfPresent(String.self, forKey: .rel)
		self.href = try container.decode(URL.self, forKey: .href)
	}
}

// MARK: - /v1/GeodeticCoordRefSystem

struct GeographicCoordRefSystem: Decodable {
	enum CodingKeys: String, CodingKey {
		case datum = "Datum"
		case datumEnsemble = "DatumEnsemble"
		case baseCoordRefSystem = "BaseCoordRefSystem"
		case conversion = "Conversion"
		case geoidModels = "GeoidModels"
		case usage = "Usage"
		case coordSys = "CoordSys"
		case kind = "Kind"
		case deformations = "Deformations"
		case code = "Code"
		case changes = "Changes"
		case alias = "Alias"
		case links = "Links"
		case name = "Name"
		case remark = "Remark"
		case dataSource = "DataSource"
		case informationSource = "InformationSource"
		case revisionDate = "RevisionDate"
		case deprecations = "Deprecations"
		case supersessions = "Supersessions"
	}

	let datum: ChildLink?
	let datumEnsemble: ChildLink?
	let baseCoordRefSystem: ChildLink?
	let conversion: ChildLink?
	let geoidModels: [ChildLink]
	let usage: [Usage]
	let coordSys: ChildLink?
	let kind: String?
	let deformations: [ChildLink]
	let code: Int
	let changes: [ChildLinkBase]
	let alias: [AliasDetails]
	let links: [Link]
	let name: String?
	let remark: String?
	let dataSource: String?
	let informationSource: String?
	let revisionDate: String?
	let deprecations: [EntityDeprecation]
	let supersessions: [EntitySupersession]

//	var isDeprecated: Bool { !self.deprecations.isEmpty }
//	var isSuperseded: Bool { !self.supersessions.isEmpty }

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.datum = try container.decodeIfPresent(ChildLink.self, forKey: .datum)
		self.datumEnsemble = try container.decodeIfPresent(ChildLink.self, forKey: .datumEnsemble)
		self.baseCoordRefSystem = try container.decodeIfPresent(ChildLink.self, forKey: .baseCoordRefSystem)
		self.conversion = try container.decodeIfPresent(ChildLink.self, forKey: .conversion)
		self.geoidModels = try container.decodeIfPresent([ChildLink].self, forKey: .geoidModels) ?? []
		self.usage = try container.decodeIfPresent([Usage].self, forKey: .usage) ?? []
		self.coordSys = try container.decodeIfPresent(ChildLink.self, forKey: .coordSys)
		self.kind = try container.decodeIfPresent(String.self, forKey: .kind)
		self.deformations = try container.decodeIfPresent([ChildLink].self, forKey: .deformations) ?? []
		self.code = try container.decode(Int.self, forKey: .code)
		self.changes = try container.decodeIfPresent([ChildLinkBase].self, forKey: .changes) ?? []
		self.alias = try container.decodeIfPresent([AliasDetails].self, forKey: .alias) ?? []
		self.links = try container.decodeIfPresent([Link].self, forKey: .links) ?? []
		self.name = try container.decodeIfPresent(String.self, forKey: .name)
		self.remark = try container.decodeIfPresent(String.self, forKey: .remark)
		self.dataSource = try container.decodeIfPresent(String.self, forKey: .dataSource)
		self.informationSource = try container.decodeIfPresent(String.self, forKey: .informationSource)
		self.revisionDate = try container.decodeIfPresent(String.self, forKey: .revisionDate)
		self.deprecations = try container.decodeIfPresent([EntityDeprecation].self, forKey: .deprecations) ?? []
		self.supersessions = try container.decodeIfPresent([EntitySupersession].self, forKey: .supersessions) ?? []
	}
}

struct ChildLink: Decodable {
	enum CodingKeys: String, CodingKey {
		case code = "Code"
		case name = "Name"
		case href
	}

	let code: Int
	let name: String?
	let href: URL

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.code = try container.decode(Int.self, forKey: .code)
		self.name = try container.decodeIfPresent(String.self, forKey: .name)
		self.href = try container.decode(URL.self, forKey: .href)
	}
}

struct Usage: Decodable {
	let Code: Int
	let Name: String?
	let ScopeDetails: String?
	let Scope: ChildLink?
	let Extent: ChildLink?
	let Links: [Link]?
	let Deprecation: [EntityDeprecation]?
	let Supersession: [EntitySupersession]?
}

struct ChildLinkBase: Decodable {
	let Code: Double?
	let Name: String?
	let href: String
}

struct AliasDetails: Decodable {
	let Code: Int
	let Alias: String?
	let NamingSystem: ChildLink?
	let Remark: String?
}
struct EntityDeprecation: Decodable {
	let Id: Int?
	let Date: String?
	let ChangeId: Double?
	let ReplacedBy: ChildLink?
	let Reason: String?
}
struct EntitySupersession: Decodable {
	let Id: Int?
	let SupersededBy: ChildLink?
	let Year: Int?
	let Remarks: String?
	let `Type`: String?
}

// MARK: - /v1/Datum

struct Datum: Decodable {
	let `Type`: String?
	let Origin: String?
	let PublicationDate: String?
	let RealizationEpoch: String?
	let Ellipsoid: ChildLink?
	let PrimeMeridian: ChildLink?
	let Usage: [Usage]?
	let MemberDatums: [ChildLink]?
	let ConventionalReferenceSystem: ChildLink?
	let FrameReferenceEpoch: Double?
	let RealizationMethod: ChildLink?
	let Code: Int?
	let Changes: [ChildLinkBase]?
	let Alias: [AliasDetails]?
	let Links: [Link]?
	let Name: String?
	let Remark: String?
	let DataSource: String?
	let InformationSource: String?
	let RevisionDate: String?
	let Deprecations: [EntityDeprecation]?
	let Supersessions: [EntitySupersession]?
}

struct UnitOfMeasure: Decodable {
	let `Type`: String?
	let TargetUnit: ChildLink?
	let FactorB: Double?
	let FactorC: Double?
	let Code: Int
	let Changes: [ChildLinkBase]?
	let Alias: [AliasDetails]?
	let Links: [Link]?
	let Name: String
	let Remark: String?
	let DataSource: String?
	let InformationSource: String?
	let RevisionDate: String?
	let Deprecations: [EntityDeprecation]?
	let Supersessions: [EntitySupersession]?
}
