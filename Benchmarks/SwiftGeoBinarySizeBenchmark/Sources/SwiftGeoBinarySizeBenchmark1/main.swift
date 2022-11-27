import WGS84

let point = Point2D(latitude: 10.2, longitude: 20.3)
print(point)
let coordinates = point.coordinates.transformed(toCRS: WGS84Geographic3DCRS.self)
print(coordinates)
print(coordinates.dmsNotation)
print(point.bbox)
