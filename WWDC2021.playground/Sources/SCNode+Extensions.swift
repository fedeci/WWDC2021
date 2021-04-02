import SceneKit

extension SCNNode {
    static func load(from filename: String, node name: String? = nil) -> SCNNode? {
        let scene = SCNScene(named: filename)!
        return scene.rootNode.childNode(withName: name ?? filename.removingFilenameExtension(), recursively: false)
    }
}
