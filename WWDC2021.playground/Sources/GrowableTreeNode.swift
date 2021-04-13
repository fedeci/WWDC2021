import SceneKit

private struct Nodes {
    static let empty = try! SCNNode.load(from: "tree.scn")
    static let sprout = try! SCNNode.load(from: "tree.scn")
    static let tree = try! SCNNode.load(from: "tree.scn")
}

final class GrowableTreeNode: SCNNode {
    enum State {
        case empty
        case sprout(creation: TimeInterval)
        case tree
        
        var associatedValue: TimeInterval? {
            switch self {
            case .sprout(let creation):
                return creation
            default:
                return nil
            }
        }
    }
    private var node: SCNNode!

    // TODO: augment physicsbody height
    private var _currentState: State = .empty {
        didSet {
            switch currentState {
            case .empty:
                node = Nodes.empty.flattenedClone()
                break
            case .sprout:
                node = Nodes.sprout.flattenedClone()
                break
            case .tree:
                node = Nodes.tree.flattenedClone()
                break
            }
            
            updatePhysicsBody()
        }
    }
    
    var currentState: State {
        get { return _currentState }
        set { _currentState = newValue }
    }
    
    init(at position: SCNVector3) {
        super.init()
        self.position = position
        self.currentState = .empty
        addChildNode(node) // This is safe to call because we are setting node with currentState
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func contactWithPlayer(_ contact: SCNPhysicsContact) {
    }
    
    func update(_ renderer: SCNSceneRenderer, at time: TimeInterval) {
        switch currentState {
        case .sprout(let creation):
            let delta = time - creation
            if delta.seconds >= 15 {
                currentState = .tree
            }
            break
        default:
            break
        }
    }
    
    private func updatePhysicsBody() {
        switch currentState {
        case .empty:
            let box = SCNBox(width: 10, height: 5, length: 10, chamferRadius: 0)
            let physicsShape = SCNPhysicsShape(geometry: box, options: nil)
            physicsBody = SCNPhysicsBody(type: .static, shape: physicsShape)
            physicsBody?.categoryBitMask = BitMask.GrowableTree.empty.rawValue
            break
        case .sprout:
            physicsBody = nil
            break
        case .tree:
            physicsBody = SCNPhysicsBody(type: .static, shape: nil)
            physicsBody?.categoryBitMask = BitMask.GrowableTree.tree.rawValue
            break
        }
    }
}
