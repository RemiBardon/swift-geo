# SwiftGeo

The toolbox for any Swift project working with geographical data.

Works on client and server sides – it's just Swift.

## To-do list

> **Note**
> Items are not especially ordered.

- Features
  - [x] Geodesic data types
  - [x] Coordinate Reference System conversions
  - Parsing/printing (using parser-printers)
    - Formats
      - [ ] GeoJSON
      - [ ] WKT
      - [ ] GPX
      - [ ] Other formats
    - [ ] Streaming
  - [ ] Full translation of [Turf](https://github.com/Turfjs/turf)
  - [ ] Integration with MapKit
  - [ ] Code generation to support all EPSG Coordinate Reference Systems
  - [ ] Dynamic Coordinate Reference System (for parsing any CRS)
- Developer experience
  - [x] Type-safety
  - [ ] Comprehensive error handling
  - [ ] Packaging
  - Documentation
    - [ ] Doc comments
    - [ ] [DocC](https://www.swift.org/documentation/docc/)
    - [ ] Illustrations
    - [ ] Online documentation
    - [ ] Use cases
  - [ ] Playground
- Tests
  - [ ] Full coverage
  - [ ] Snapshot testing
- Platform compatibility
  - [ ] macOS (`MapKit` integration)
  - [ ] Others (open-source `Foundation`…)
- Benchmarks
  - [ ] Binary size benchmarks (`@inlinable`, optimizations…)
  - [ ] Performance benchmarks (CPU, RAM…)

## Development and maintenance

- This repository is being actively developed.
- It will be maintained, but not actively.
- PRs are welcome ❤️ They will be reviewed and integrated unless something is wrong.
