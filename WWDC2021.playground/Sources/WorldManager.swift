import SceneKit
import GameplayKit

final class WorldManager: NSObject {
    private var width: Int32!
    private var depth: Int32!
    private var scaleFactor: SCNVector3!

    private var parentNode = SCNNode()
    private var staticTreeNodes: [SCNNode] = []
    private var growableTreeNodes: [GrowableTreeNode] = []

    private lazy var terrainGeometry: SCNGeometry = {
       return generateTerrainGeometry()
    }()

    init(_ width: Int, _ depth: Int, _ scaleFactor: SCNVector3) {
        super.init()
        self.width = Int32(width)
        self.depth = Int32(depth)
        self.scaleFactor = scaleFactor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func generateWorldNode() -> SCNNode {
        terrainGeometry.firstMaterial?.diffuse.contents = UIColor.green
        terrainGeometry.firstMaterial?.isDoubleSided = true
        let terrainNode = SCNNode(geometry: terrainGeometry)
        generateTerrainPhysicsBody(node: terrainNode)

        parentNode.addChildNode(terrainNode)
        return parentNode
    }

    /// This generates also static trees (treeNodes) and growable trees (growableTreeNodes)
    private func generateTerrainGeometry() -> SCNGeometry {
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

    // MARK: - Trees
    private func shouldGenerateTreeFor(_ value: Float) -> Bool {
        return (Int(floor(value * 100)) % 7) == 0
    }

    private func generateTreeAt(_ position: SCNVector3) {
        guard shouldGenerateTreeFor(position.y) else { return }
        Bool.random()
            ? generateStaticTreeAt(position)
            : generateGrowableTreeAt(position)
    }
    
    private func generateGrowableTreeAt(_ position: SCNVector3) {
        let growableTree = GrowableTreeNode(at: position, scale: scaleFactor)
        growableTreeNodes.append(growableTree)
        parentNode.addChildNode(growableTree)
    }
    
    private func generateStaticTreeAt(_ position: SCNVector3) {
        let node = try! SCNNode.load(from: Bool.random() ? "tree.scn" : "tree-2.scn")
        node.scaleToFit(height: scaleFactor.y * 1.2)
        node.position = position
        generateTreePhysicsBody(node: node)
        
        staticTreeNodes.append(node)
        parentNode.addChildNode(node)
    }
    
    // MARK: - Physics
    private func generateTerrainPhysicsBody(node: SCNNode) {
        let shape = SCNPhysicsShape(node: node, options: [.type: SCNPhysicsShape.ShapeType.concavePolyhedron])
        node.physicsBody = SCNPhysicsBody(type: .static, shape: shape)
        node.physicsBody?.categoryBitMask = BitMask.world.rawValue
    }
    
    private func generateTreePhysicsBody(node: SCNNode) {
        node.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        node.physicsBody?.categoryBitMask = BitMask.staticTree.rawValue
    }
    
    // MARK: - Render loop
    func update(_ renderer: SCNSceneRenderer, at time: TimeInterval) {
        growableTreeNodes.forEach({ $0.update(renderer, at: time) })
    }
}
