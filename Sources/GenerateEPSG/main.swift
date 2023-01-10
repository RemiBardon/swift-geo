//
//  main.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 06/12/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import Foundation
import Stencil

let environment = Environment()

let session = URLSession.shared

let urlString = "https://apps.epsg.org/api/v1/CoordRefSystem/"
guard var endpoint = URLComponents(string: urlString) else {
	exit(EXIT_FAILURE)
}

let template = """
{% if crs.name %}\
/// - Name: {{ crs.name }}
{% endif %}\
{% if crs.type %}\
/// - Type: {{ type }}
{% endif %}\
{% if crs.dataSource %}\
/// - DataSource: {{ crs.dataSource }}
{% endif %}\
{% if crs.area %}\
/// - Area: {{ crs.area }}
{% endif %}\
{% if crs.remarks %}\
/// - Remarks: {{ crs.remarks }}
{% endif %}\
/// - Superseded: `{{ crs.supersessions.isEmpty == false }}`
{% if crs.revisionDate %}\
/// - RevisionDate: `{{ crs.revisionDate }}`
{% endif %}\
{% if crs.deprecated == true %}\
@available(*, deprecated)
{% endif %}\
enum EPSG{{ crs.code }}: {{ swiftType }} {

}
"""

let api = EPSGAPI()

let decoder = JSONDecoder()
for i in 0...0 {
	endpoint.queryItems = [
		URLQueryItem(name: "page", value: String(describing: i)),
	]
	guard let url: URL = endpoint.url else { continue }
	let results = try await api.get(SearchResults.self, from: url)

	for result in results.results {
		guard result.type.isSupported else {
			print("CRS type \"\(result.type.rawValue)\" not supported")
			continue
		}

		if let url = result.links.first?.href {
			let crs: GeographicCoordRefSystem = try await api.get(GeographicCoordRefSystem.self, from: url)
			print(crs)

			guard let datumUrl = crs.datum?.href else {
				print("CRS `\(crs.code)` has no datum: \(crs)")
				continue
			}
			let datum = try await api.get(Datum.self, from: datumUrl)
			print(datum)

			let context: [String : Any] = [
				"type": result.type.rawValue,
				"swiftType": result.type.swiftType,
				"crs": crs,
				"datum": datum,
			]
			let code = try environment.renderTemplate(string: template, context: context)
			print(code)
		}
	}
}

actor EPSGAPI {
	private var cache = [URL: Any]()

	func get<T: Decodable>(_ type: T.Type, from url: URL) async throws -> T {
		if let res = cache[url] as? T {
			print("🎯 Cache hit: \(url)")
			return res
		}

		let (data, response) = try await session.data(from: url)
		guard let response = response as? HTTPURLResponse else {
			throw URLError(.badServerResponse)
		}
		guard (200..<300).contains(response.statusCode) else {
			throw URLError(.badServerResponse)
		}
		let res = try decoder.decode(type, from: data)

		cache[url] = res
		return res
	}
}

// curl -X GET --header 'Accept: application/json' 'https://apps.epsg.org/api/v1/GeodeticCoordRefSystem/4168'
//{"Datum":{"Code":6168,"Name":"Accra","href":"https://apps.epsg.org/api/v1/Datum/6168"},"DatumEnsemble":null,"BaseCoordRefSystem":null,"Conversion":null,"GeoidModels":[],"Usage":[{"Code":3053,"Name":"Ghana","ScopeDetails":"Geodesy.","Scope":{"Code":1027,"Name":"Geodesy.","href":"https://apps.epsg.org/api/v1/Scope/1027"},"Extent":{"Code":1104,"Name":"Ghana","href":"https://apps.epsg.org/api/v1/Extent/1104"},"Links":[],"Deprecation":null,"Supersession":null}],"CoordSys":{"Code":6422,"Name":"Ellipsoidal 2D CS. Axes: latitude, longitude. Orientations: north, east. UoM: degree","href":"https://apps.epsg.org/api/v1/CoordSystem/6422"},"Kind":"geographic 2D","Deformations":[],"Code":4168,"Changes":[{"Code":2003.37,"href":"https://apps.epsg.org/api/v1/Change/2003.37"}],"Alias":[],"Links":[{"rel":"self","href":"https://apps.epsg.org/api/v1/GeodeticCoordRefSystem/4168"}],"Name":"Accra","Remark":"Ellipsoid semi-major axis (a)=20926201 exactly Gold Coast feet. \r\nReplaced by Leigon (code 4250) in 1978.","DataSource":"EPSG","InformationSource":"Ordnance Survey International","RevisionDate":"2004-01-06T00:00:00","Deprecations":[],"Supersessions":[]}
