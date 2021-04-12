import SceneKit

enum MainSceneError: Error {
    case noView
}

public final class MainScene: SCNScene {
    static let scale = SCNVector3(20, 35, 20)

    weak var view: SCNView?
    private var worldManager: WorldManager!
    private var world: SCNNode!
    private var sun: Sun!
    private var mainCharacter: Character!
    private var diffusedLightNode: SCNNode!
    private var overlay: OverlayScene!
    private var cameraNode: SCNNode!

    public init(view: SCNView) {
        super.init()
        self.view = view
        setupWorld()
        setupMainCharacter()
        setupDiffusedLight()
        setupSun()
        setupMusic()
        try! setupOverlay()
        setupPhysics()
        setupCameraNode()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupWorld() {
        worldManager = WorldManager(20, 20, MainScene.scale)
        world = worldManager.generateWorldNode()
        world.position = SCNVector3(0, 0, 0)

        rootNode.addChildNode(world)
    }

    private func setupDiffusedLight() {
        diffusedLightNode = SCNNode()
        let light = SCNLight()
        light.type = .ambient
        light.intensity = 200
        diffusedLightNode.light = light

        rootNode.addChildNode(diffusedLightNode)
    }

    private func setupSun() {
        sun = Sun(initialPosition: SCNVector3(60, 300, 60))
        rootNode.addChildNode(sun.lightNode)
    }

    private func setupMainCharacter() {
        mainCharacter = Character(initialPosition: SCNVector3(60, 0, 60), physicsWorld: physicsWorld)
        rootNode.addChildNode(mainCharacter.rootNode)
    }
    
    private func setupMusic() {
        AudioManager.shared.playChillMusic()
    }
    
    private func setupOverlay() throws {
        guard let view = view else { throw MainSceneError.noView }
        overlay = OverlayScene(size: view.bounds.size, delegate: self)
        view.overlaySKScene = overlay
    }
    
    private func setupPhysics() {
        physicsWorld.contactDelegate = self
    }
    
    private func setupCameraNode() {
        cameraNode = SCNNode()
        let camera = SCNCamera()
        camera.zFar = 1000
        camera.fieldOfView = 90
        cameraNode.camera = camera
        
        let lookAtConstraint = SCNLookAtConstraint(target: mainCharacter.rootNode)
        lookAtConstraint.isGimbalLockEnabled = true
        let distanceConstraint = SCNDistanceConstraint(target: mainCharacter.rootNode)
        distanceConstraint.minimumDistance = 50
        distanceConstraint.maximumDistance = 70
        let transformConstraint = SCNTransformConstraint.positionConstraint(inWorldSpace: true) { [weak self] _, position -> SCNVector3 in
            guard let self = self else { return position }
            var newPosition = position
            newPosition.y = self.mainCharacter.rootNode.boundingBox.max.y + 30
            return newPosition
        }
        
        cameraNode.constraints = [lookAtConstraint, distanceConstraint, transformConstraint]
        rootNode.addChildNode(cameraNode)

        view?.pointOfView = cameraNode
    }
}

extension MainScene: JoystickDelegate {
    func positionChanged(_ joystick: Joystick, distance: CGFloat, alpha: CGFloat) {
        mainCharacter.updateDirection(distance, alpha: alpha)
    }
}

extension MainScene: SCNPhysicsContactDelegate {
    public func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        // this will be useful for planting trees
    }
}

extension MainScene: SCNSceneRendererDelegate {
    public func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        mainCharacter.update()
        worldManager.update(renderer, at: time)
    }
}
