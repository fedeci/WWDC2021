import SceneKit


class Character: NSObject {
    private(set) var characterNode: SCNNode!
    private var characterHeight: Float!
    
    init(height: Float, initialPosition position: SCNVector3) {
        super.init()
        characterHeight = height
        setupCharacterNode(initialPosition: position)
    }
    
    private func setupCharacterNode(initialPosition position: SCNVector3) {
        characterNode = try! SCNNode.load(from: "character.scn")
        characterNode.scaleToFit(height: characterHeight)

        characterNode.position = position
    }
}
