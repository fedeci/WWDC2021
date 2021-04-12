import SceneKit

private struct Nodes {
    static let empty = try! SCNNode.load(from: "insert")
    static let sprout = try! SCNNode.load(from: "insert")
    static let tree = try! SCNNode.load(from: "insert")
}

final class GrowableTree: NSObject {
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

    private var position: SCNVector3!
    private(set) var node: SCNNode!

    private var _currentState: State = .empty {
        didSet {
            switch currentState {
            case .empty:
                print(Nodes.empty)
                node = Nodes.empty.flattenedClone()
                break
            case .sprout:
                node = Nodes.sprout.flattenedClone()
                break
            case .tree:
                node = Nodes.tree.flattenedClone()
                break
            }
            node.position = position
            
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
        case .empty, .sprout:
            break
        case .tree:
            break
        }
    }
}
