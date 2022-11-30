//
//  WGS84.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 01/10/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import Geodesy

// MARK: - Coordinates

public typealias Coordinate2D = WGS84Geographic2DCRS.Coordinates
public typealias Coordinate3D = WGS84Geographic3DCRS.Coordinates

// MARK: - Coordinate Reference System (CRS/SRS)

/// <https://epsg.org/crs_4326/WGS-84.html>
public enum WGS84Geographic2DCRS: GeographicCRS, TwoDimensionalCRS {
	public typealias Datum = WGS84Ensemble
	public typealias CoordinateSystem = Ellipsoidal2DCS
	public typealias Coordinates = Coordinates2DOf<Self>

	public static let epsgName: String = "WGS 84 (geographic 2D)"
	public static let epsgCode: Int = 4326
}

public typealias EPSG4326 = WGS84Geographic2DCRS

/// <https://epsg.org/crs_4979/WGS-84.html>
public enum WGS84Geographic3DCRS: GeographicCRS, ThreeDimensionalCRS {
	public typealias Datum = WGS84Ensemble
	public typealias CoordinateSystem = Ellipsoidal3DCS
	public typealias Coordinates = Coordinates3DOf<Self>

	public static let epsgName: String = "WGS 84 (geographic 3D)"
	public static let epsgCode: Int = 4979
}

public typealias EPSG4979 = WGS84Geographic3DCRS

/// <https://epsg.org/crs_4978/WGS-84.html>
public enum WGS84GeocentricCRS: GeocentricCRS, ThreeDimensionalCRS {
	public typealias Datum = WGS84Ensemble
	public typealias CoordinateSystem = GeocentricCartesian3DCS
	public typealias Coordinates = Coordinates3DOf<Self>

	public static let epsgName: String = "WGS 84 (geocentric)"
	public static let epsgCode: Int = 4978
}

public typealias EPSG4978 = WGS84GeocentricCRS

// MARK: - Datum

public enum WGS84Ensemble: DatumEnsemble {
	public typealias Ellipsoid = EPSG7030
	public typealias PrimeMeridian = Greenwich
	public typealias PrimaryMember = Member7
	public static let epsgName: String = "World Geodetic System 1984 ensemble"
	public static let epsgCode: Int = 6326

	public enum Member7: DatumEnsembleMember {
		public typealias Ellipsoid = EPSG7030
		public typealias PrimeMeridian = Greenwich
		public static let epsgName: String = "World Geodetic System 1984 (G2139)"
		public static let epsgCode: Int = 1309
	}
}

/// <https://epsg.io/6326-datum>
/// <https://epsg.org/crs_6326/WGS-84.html>
public typealias EPSG6326 = WGS84Ensemble

public typealias EPSG1309 = WGS84Ensemble.Member7

// MARK: Reference Ellipsoid

/// World Geodetic System 1984 ensemble member 7 ellipsoid
/// <https://epsg.org/ellipsoid_7030/WGS-84.html>
public enum EPSG7030: ReferenceEllipsoid {
	public static let epsgName: String = "WGS 84"
	public static let epsgCode: Int = 7030
	public static let semiMajorAxis: Double = 6378137
	public static let inverseFlattening: Double = 298.257_223_563
}
