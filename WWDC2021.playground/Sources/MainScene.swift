import SceneKit

public final class MainScene: SCNScene {
    private let scale = SCNVector3(20, 35, 20)
    private var terrainGenerator: TerrainGenerator!
    private var sun: Sun!
    private var mainCharacter: Character!

    public override init() {
        super.init()
        setupTerrain()
        setupMainCharacter()
        setupSun()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTerrain() {
        terrainGenerator = TerrainGenerator(20, 20, scale)
        let node = terrainGenerator.terrain()
        node.position = SCNVector3(0, 0, 0)

        rootNode.addChildNode(node)
    }

    private func setupSun() {
        sun = Sun(initialPosition: SCNVector3(60, 300, 60))
        rootNode.addChildNode(sun.lightNode)
    }

    private func setupMainCharacter() {
        mainCharacter = Character(height: scale.y * 0.3, initialPosition: SCNVector3(60, 10, 60))
        rootNode.addChildNode(mainCharacter.characterNode)
    }
}
