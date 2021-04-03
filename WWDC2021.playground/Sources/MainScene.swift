import SceneKit

private let SCALE = SCNVector3(20, 35, 20)

public class MainScene: SCNScene {
    private let generator = TerrainGenerator(20, 20, SCALE)
    private var timerCounter = 0
    private var sun: Sun!

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
        let node = generator.terrain()
        node.position = SCNVector3(0, 0, 0)

        rootNode.addChildNode(node)
    }
    
    private func setupSun() {
        sun = Sun(initialPosition: SCNVector3(60, 300, 60))
        rootNode.addChildNode(sun.lightNode)
    }
    
    private func setupMainCharacter() {
        let node = try! SCNNode.load(from: "character.scn")
        node.scaleToFit(height: SCALE.y * 0.3)
        node.position = SCNVector3(60, 10, 60)
        rootNode.addChildNode(node)
    }
}
