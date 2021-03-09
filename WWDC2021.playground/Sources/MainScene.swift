import SceneKit

public class MainScene: SCNScene {
    let generator = TerrainGenerator(20, 20, SCNVector3(20, 35, 20))
    
    public override init() {
        super.init()
        setupTerrain()
        setupLight()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupTerrain() {
        let node = generator.terrain()
        node.position = SCNVector3(0, 0, 0)
        
        rootNode.addChildNode(node)
    }
    
    private func setupLight() {
        let node = SCNNode()
        let light = SCNLight()
        light.type = .omni
        
        node.light = light
        node.position = SCNVector3(60, 120, 60)
        rootNode.addChildNode(node)
    }
}
