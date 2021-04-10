import SceneKit

enum MainSceneError: Error {
    case noView
}

public final class MainScene: SCNScene {
    static let scale = SCNVector3(20, 35, 20)

    weak var view: SCNView?
    private var terrain: SCNNode!
    private var sun: Sun!
    private var mainCharacter: Character!
    private var diffusedLightNode: SCNNode!
    private var overlay: OverlayScene!

    public init(view: SCNView) {
        super.init()
        self.view = view
        setupTerrain()
        setupMainCharacter()
        setupDiffusedLight()
        setupSun()
        setupMusic()
        try! setupOverlay()
        setupPhysics()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTerrain() {
        let terrainGenerator = TerrainGenerator(20, 20, MainScene.scale)
        terrain = terrainGenerator.generate()
        terrain.position = SCNVector3(0, 0, 0)

        rootNode.addChildNode(terrain)
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
        mainCharacter.update(atTime: time, with: renderer)
    }
}
