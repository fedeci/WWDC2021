import SceneKit

final class Character: NSObject {
    let rootNode = SCNNode()
    private var characterNode: SCNNode!
    private var scenePhysicsWorld: SCNPhysicsWorld!
    
    private var direction = SCNVector3Zero

    init(
        initialPosition position: SCNVector3,
        physicsWorld scenePhysicsWorld: SCNPhysicsWorld
    ) {
        super.init()
        rootNode.position = position
        self.scenePhysicsWorld = scenePhysicsWorld

        setupCharacterNode()
    }

    private func setupCharacterNode() {
        characterNode = try! SCNNode.load(from: "character.scn")

        rootNode.addChildNode(characterNode)
        setupPhysics()
    }
    
    private func setupPhysics() {
        characterNode.physicsBody = SCNPhysicsBody(type: .kinematic, shape: nil)
        characterNode.physicsBody?.categoryBitMask = BitMask.character.rawValue
    }
    
    func updateDirection(_ distance: CGFloat, alpha: CGFloat) {
        direction = SCNVector3(distance * cos(alpha), 0, distance * sin(alpha))
    }
    
    func update(atTime time: TimeInterval, with renderer: SCNSceneRenderer) {
        let oldPosition = rootNode.position
        
        let newPosition = direction + oldPosition
        rootNode.position = newPosition
        
        var origin = newPosition
        origin.y -= 1
        var dest = newPosition
        dest.y += (rootNode.boundingBox.max.y - rootNode.boundingBox.min.y)

        if let result = scenePhysicsWorld.rayTestWithSegment(
            from: origin,
            to: dest,
            options: [
                .collisionBitMask: BitMask.world.rawValue,
                .searchMode: SCNPhysicsWorld.TestSearchMode.closest,
                .backfaceCulling: false
            ]
        ).first {
            rootNode.position.y = result.worldCoordinates.y
        } else {
            rootNode.position = oldPosition
        }
    }
}
