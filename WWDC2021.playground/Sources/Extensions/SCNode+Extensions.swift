import SceneKit

enum LoadingError: Error {
    case sceneError(String)
    case childNodeNotFound(String)
}

extension SCNNode {
    static func load(from filename: String, node name: String? = nil) throws -> SCNNode {
        guard let scene = SCNScene(named: filename, inDirectory: "Assets.scnassets", options: [.createNormalsIfAbsent: true]) else {
            throw LoadingError.sceneError(filename)
        }
        let childName = name ?? filename.removingFilenameExtension()
        if let node = scene.rootNode.childNode(withName: childName, recursively: false) {
            return node
        }
        throw LoadingError.childNodeNotFound(childName)
    }

    func scaleToFit(height: Float) {
        let ratio = height / boundingBox.max.y
        scale = SCNVector3(ratio, ratio, ratio)
    }
}
