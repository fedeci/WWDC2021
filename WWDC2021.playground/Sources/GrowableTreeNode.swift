import SceneKit

final class GrowableTreeNode: SCNNode {
    enum State: Equatable {
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
    
    var shouldUpdate = false
    private var node: SCNNode?
    private var worldScale: SCNVector3!

    private var _currentState: State = .empty {
        didSet {
            switch currentState {
            case .empty:
                node = (try! SCNNode.load(from: "sprout.scn", node: "ground")).scaleToFit(height: worldScale.y * 0.1)
                break
            case .sprout:
                let plantNode = try! SCNNode.load(from: "sprout.scn", node: "plant")
                node?.addChildNode(plantNode)
                break
            case .tree:
                node?.removeFromParentNode()
                node = try! SCNNode.load(from: Bool.random() ? "tree.scn" : "tree-2.scn").scaleToFit(height: worldScale.y * 1.2)
                break
            }
            addChildNode(node!)
            
            updatePhysicsBody()
        }
    }
    
    var currentState: State {
        get { return _currentState }
        set { _currentState = newValue }
    }
    
    init(at position: SCNVector3, scale: SCNVector3) {
        super.init()
        worldScale = scale
        self.position = position
        self.currentState = .empty
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(_ renderer: SCNSceneRenderer, at time: TimeInterval) {
        switch currentState {
        case .empty:
            if shouldUpdate {
                currentState = .sprout(creation: time)
                shouldUpdate = false
            }
            break
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
            let physicsShape = SCNPhysicsShape(geometry: SCNSphere(radius: 8), options: nil)
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
