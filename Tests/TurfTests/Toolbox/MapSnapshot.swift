//
//  MapSnapshot.swift
//  SwiftGeo
//
//  Created by Rémi Bardon on 19/09/2022.
//  Copyright © 2022 Rémi Bardon. All rights reserved.
//

import GeoModels
import MapKit
import XCTest

@MainActor
func snapshot(
	_ lineString: LineString2D,
	mapType: MKMapType = .standard,
	file: StaticString = #file,
	line: UInt = #line
) async throws -> NSImage {
	let frame = NSRect(origin: .zero, size: CGSize(width: 512, height: 512))
	let mapView = MKMapView(frame: frame)
	let delegate = MapDelegate()
	mapView.delegate = delegate

	mapView.mapType = mapType

	var region = lineString.bbox.mkCoordinateRegion
	region.span.latitudeDelta += 1
	region.span.longitudeDelta += 1
	mapView.setRegion(region, animated: false)
	mapView.setNeedsDisplay(mapView.bounds)
	mapView.display()

	var points: [CLLocationCoordinate2D] = lineString.points.map {
		// Fix the fact that (0,0) coordinates are not rendered on a map (special value in MapKit)
		$0 == .zero
			? CLLocationCoordinate2D(latitude: 0.001, longitude: 0.001)
			: $0.clLocationCoordinate2D
	}
	let polyline = MKPolyline(coordinates: &points, count: points.count)
	assert(points.count == polyline.pointCount)
	mapView.addOverlay(polyline, level: .aboveRoads)

	while (!delegate.renderingFinished) {
		try await Task.sleep(nanoseconds: 100 * NSEC_PER_MSEC)
	}
	return mapView.snapshot
}

extension NSView {
	var snapshot: NSImage {
		guard let bitmapRep = bitmapImageRepForCachingDisplay(in: bounds) else { return NSImage() }
		bitmapRep.size = bounds.size
		cacheDisplay(in: bounds, to: bitmapRep)
		let image = NSImage(size: bounds.size)
		image.addRepresentation(bitmapRep)
		return image
	}
}

final class MapDelegate: NSObject, MKMapViewDelegate {

	var renderingFinished = false

	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
		if overlay is MKPolyline {
			let renderer = MKPolylineRenderer(overlay: overlay)
			renderer.strokeColor = NSColor.red
			renderer.lineWidth = 3
			return renderer
		}
		return MKOverlayRenderer()
	}

	func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
		self.renderingFinished = true
	}

}