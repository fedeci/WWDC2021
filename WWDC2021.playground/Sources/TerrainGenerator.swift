import SceneKit
import GameplayKit

final class TerrainGenerator: NSObject {
    private var width: Int32
    private var depth: Int32
    private var scaleFactor: SCNVector3

    private var parentNode = SCNNode()
    private var treeNodes: [SCNNode] = []
    private lazy var terrainGeometry: SCNGeometry = {
       return generateGeometry()
    }()

    init(_ width: Int, _ depth: Int, _ scaleFactor: SCNVector3) {
        self.width = Int32(width)
        self.depth = Int32(depth)
        self.scaleFactor = scaleFactor
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func generate() -> SCNNode {
        terrainGeometry.firstMaterial?.diffuse.contents = UIColor.green
        terrainGeometry.firstMaterial?.isDoubleSided = true
        let terrainNode = SCNNode(geometry: terrainGeometry)
        generateTerrainPhysicsBody(node: terrainNode)

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
                let h = abs(noiseMap.value(at: vector_int2(w, d)))
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

    private func shouldGenerateTreeFor(_ value: Float) -> Bool {
        return (Int(floor(value * 100)) % 4) == 0
    }

    private func generateTreeAt(_ position: SCNVector3) {
        guard shouldGenerateTreeFor(position.y) else { return }

        let node = try! SCNNode.load(from: Bool.random() ? "tree.scn" : "tree-2.scn")
        node.scaleToFit(height: scaleFactor.y * 1.2)
        node.position = position
        generateTreePhysicsBody(node: node)
        
        treeNodes.append(node)
        parentNode.addChildNode(node)
    }
    
    private func generateTerrainPhysicsBody(node: SCNNode) {
        let shape = SCNPhysicsShape(node: node, options: [.type: SCNPhysicsShape.ShapeType.concavePolyhedron])
        node.physicsBody = SCNPhysicsBody(type: .static, shape: shape)
        node.physicsBody?.categoryBitMask = BitMask.world.rawValue
    }
    
    private func generateTreePhysicsBody(node: SCNNode) {
        node.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        node.physicsBody?.categoryBitMask = BitMask.tree.rawValue
    }
}
