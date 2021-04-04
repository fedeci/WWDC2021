import SceneKit
import GameplayKit

final class TerrainGenerator: NSObject {
    private var width: Int32!
    private var depth: Int32!
    private var scaleFactor: SCNVector3!
    private var bottomHeight: Float!
    
    private var parentNode = SCNNode()
    private var treeNodes: [SCNNode] = []
    private lazy var terrainGeometry: SCNGeometry = {
        return generateGeometry()
    }()

    init(_ width: Int, _ depth: Int, _ scaleFactor: SCNVector3, _ bottomHeight: Float) {
        super.init()
        self.bottomHeight = bottomHeight
        self.width = Int32(width)
        self.depth = Int32(depth)
        self.scaleFactor = scaleFactor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func terrain() -> SCNNode {
        terrainGeometry.firstMaterial?.diffuse.contents = UIColor.green
        let terrainNode = SCNNode(geometry: terrainGeometry)

        parentNode.addChildNode(terrainNode)
        return parentNode
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
                generateTreeAt(vertex)
                vertices.append(vertex)

                if d < depth - 1 && w < width - 1 {
                    indices.append(contentsOf: [counter, counter + depth + 1, counter + depth])
                    indices.append(contentsOf: [counter, counter + 1, counter + depth + 1])
                }
                counter += 1
            }
        }
        
        closeTerrainBottom(vertices: &vertices, indices: &indices)
        
        let vertexSource = SCNGeometrySource(vertices: vertices)
        let element = SCNGeometryElement(indices: indices, primitiveType: .triangles)

        return SCNGeometry(sources: [vertexSource], elements: [element])
    }

    // this works like magic
    private func closeTerrainBottom(vertices: inout [SCNVector3], indices: inout [Int32]) {
        let baseHeight = -abs(bottomHeight)
        var counter = Int32(vertices.count)
        var bottomVertices: [SCNVector3] = []
        var bottomIndices: [Int32] = []
        
        
        // Create sides
        for w in 0..<width {
            // Depth: 0 and width: w
            bottomVertices.append(SCNVector3(Float(w) * scaleFactor.x, baseHeight, 0))
            if (w < width - 1) {
                bottomIndices.append(contentsOf: [getTopVertexIndexAt(w, 0), counter + 2, counter])
                bottomIndices.append(contentsOf: [getTopVertexIndexAt(w + 1, 0), counter + 2, getTopVertexIndexAt(w, 0)])
            }
            counter += 1
            // Depth: depth and width: w
            bottomVertices.append(SCNVector3(Float(w) * scaleFactor.x, baseHeight, Float(depth - 1) * scaleFactor.z))
            if (w < width - 1) {
                bottomIndices.append(contentsOf: [counter, counter + 2, getTopVertexIndexAt(w, depth - 1)])
                bottomIndices.append(contentsOf: [getTopVertexIndexAt(w, depth - 1), counter + 2, getTopVertexIndexAt(w + 1, depth - 1)])
            }
            counter += 1
        }
        
        
        vertices.append(contentsOf: bottomVertices)
        indices.append(contentsOf: bottomIndices)
    }
    
    /// Get one vertex index position (of the top plane)
    private func getTopVertexIndexAt(_ width: Int32, _ depth: Int32) -> Int32 {
        return width * self.depth + depth
    }
    
    private func generateNoiseMap() -> GKNoiseMap {
        let noiseSource = GKPerlinNoiseSource()

        let noise = GKNoise(noiseSource)

        let mapSize = vector_double2(1, 1)
        let mapOrigin = vector_double2(0, 0)
        let mapSampleCount = vector_int2(width, depth)
        return GKNoiseMap(noise, size: mapSize, origin: mapOrigin, sampleCount: mapSampleCount, seamless: true)
    }

    private func shouldGenerateTreeFor(_ value: Float) -> Bool {
        return Int(floor(value * 100)) % 7 == 0
    }

    private func generateTreeAt(_ position: SCNVector3) {
        guard shouldGenerateTreeFor(position.y) else { return }
        let node = try! SCNNode.load(from: Bool.random() ? "tree.scn" : "tree-2.scn")
        node.scaleToFit(height: scaleFactor.y * 1.2)
        node.position = position

        treeNodes.append(node)
        parentNode.addChildNode(node)
    }
}
