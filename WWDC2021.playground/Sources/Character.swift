import SceneKit

final class Character: NSObject {
    private var scenePhysicsWorld: SCNPhysicsWorld!
    let rootNode = SCNNode()

    private var characterNode: SCNNode!
    private var joystickDirection = SCNVector3Zero

    private(set) var cameraNode: SCNNode!
    private var lookAtNode: SCNNode!
    var directionAngle: CGFloat = 0

    init(
        initialPosition position: SCNVector3,
        physicsWorld scenePhysicsWorld: SCNPhysicsWorld
    ) {
        super.init()
        self.scenePhysicsWorld = scenePhysicsWorld
        setupRootNode(position: position)
        setupCharacterNode()
    }
    
    private func setupRootNode(position: SCNVector3) {
        rootNode.rotation = SCNVector4(0, Float.pi / 2, 0, 0)
        rootNode.position = position
    }

    private func setupCharacterNode() {
        characterNode = try! SCNNode.load(from: "character.scn")

        rootNode.addChildNode(characterNode)
        setupPhysics()
        setupCameraNode()
    }
    
    private func setupCameraNode() {
        let camera = SCNCamera()
        camera.zFar = 1000
        camera.fieldOfView = 90
        
        cameraNode = SCNNode()
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(0, 40, -45)
        
        lookAtNode = SCNNode()
        rootNode.addChildNode(lookAtNode)
        let lookAtConstraint = SCNLookAtConstraint(target: lookAtNode)
        lookAtConstraint.isGimbalLockEnabled = true
        
        cameraNode.constraints = [lookAtConstraint]
        rootNode.addChildNode(cameraNode)
    }
    
    private func setupPhysics() {
        characterNode.physicsBody = SCNPhysicsBody(type: .kinematic, shape: nil)
        characterNode.physicsBody?.categoryBitMask = BitMask.character.rawValue
        characterNode.physicsBody?.contactTestBitMask = BitMask.GrowableTree.empty.rawValue
    }
    
    func updateJoystickDirection(_ distance: CGFloat, alpha: CGFloat) {
        joystickDirection = SCNVector3(
            distance * sin(alpha + CGFloat(rootNode.rotation.w) - .pi / 2),
            0,
            distance * cos(alpha + CGFloat(rootNode.rotation.w) - .pi / 2)
        )
    }
    
    func update() {
        // Update node rotation
        let action = SCNAction.rotateBy(x: 0, y: directionAngle, z: 0, duration: 0.2)
        rootNode.runAction(action)

        // Update node position
        let oldPosition = rootNode.position
        
        let newPosition = joystickDirection + oldPosition
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
