import SceneKit
import GameplayKit

class TerrainGenerator: NSObject {
    private(set) var width: Int32
    private(set) var depth: Int32
    private(set) var scaleFactor: SCNVector3
    private(set) var geometry: SCNGeometry?

    init(_ width: Int, _ depth: Int, _ scaleFactor: SCNVector3) {
        self.width = Int32(width)
        self.depth = Int32(depth)
        self.scaleFactor = scaleFactor
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func terrain() -> SCNNode {
        let geometry = generateGeometry()
        geometry.firstMaterial?.diffuse.contents = UIColor.green
        return SCNNode(geometry: geometry)
    }

    private func generateGeometry() -> SCNGeometry {
        let noiseMap = generateNoiseMap()
        var vertices: [SCNVector3] = []
        var indices: [Int32] = []
        var counter: Int32 = 0

        // swiftlint:disable identifier_name
        for w in 0..<width {
            // swiftlint:disable identifier_name
            for d in 0..<depth {
                // swiftlint:disable identifier_name
                let h = noiseMap.value(at: vector_int2(w, d))
                let vertex = SCNVector3(Float(w), h, Float(d)) * scaleFactor
                vertices.append(vertex)

                if d < depth - 1 && w < width - 1 {
                    indices.append(contentsOf: [counter, counter + depth + 1, counter + depth])
                    indices.append(contentsOf: [counter, counter + 1, counter + depth + 1])
                }
                counter += 1
            }
        }

        let vertexSource = SCNGeometrySource(vertices: vertices)
        let element = SCNGeometryElement(indices: indices, primitiveType: .triangles)

        return SCNGeometry(sources: [vertexSource], elements: [element])
    }

    private func generateNoiseMap() -> GKNoiseMap {
        let noiseSource = GKPerlinNoiseSource()

        let noise = GKNoise(noiseSource)

        let mapSize = vector_double2(1, 1)
        let mapOrigin = vector_double2(0, 0)
        let mapSampleCount = vector_int2(width, depth)
        return GKNoiseMap(noise, size: mapSize, origin: mapOrigin, sampleCount: mapSampleCount, seamless: true)
    }
}
