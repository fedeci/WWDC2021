import SceneKit

enum MainSceneError: Error {
    case noView
}

public final class MainScene: SCNScene {
    static let scale = SCNVector3(20, 35, 20)

    weak var view: SCNView?
    private var terrainGenerator: TerrainGenerator!
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
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTerrain() {
        terrainGenerator = TerrainGenerator(20, 20, MainScene.scale)
        let node = terrainGenerator.terrain()
        node.position = SCNVector3(0, 0, 0)

        rootNode.addChildNode(node)
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
        mainCharacter = Character(height: MainScene.scale.y * 0.3, initialPosition: SCNVector3(60, 10, 60))
        rootNode.addChildNode(mainCharacter.characterNode)
    }
    
    private func setupMusic() {
        AudioManager.shared.playChillMusic()
    }
    
    private func setupOverlay() throws {
        guard let view = view else { throw MainSceneError.noView }
        overlay = OverlayScene(size: view.bounds.size, delegate: self)
        view.overlaySKScene = overlay
    }
}

extension MainScene: JoystickDelegate {
    func positionChanged(_ joystick: Joystick, distance: CGFloat, alpha: CGFloat) { }
}
