import SceneKit

enum MainSceneError: Error {
    case noView
}

public final class MainScene: SCNScene {
    static let scale = SCNVector3(20, 35, 20)

    weak var view: SCNView?
    private var worldManager: WorldManager!
    private var world: SCNNode!
    private var sun: Sun!
    private var mainCharacter: Character!
    private var diffusedLightNode: SCNNode!
    private var overlay: OverlayScene!
    private var cameraNode: SCNNode!
    
    private var nPhysicsContacts: UInt = 0 {
        didSet {
            if nPhysicsContacts == 0 {
                overlay.plantSproutButton.isEnabled = false
                lastPhysicsContact = nil
            }
        }
    }
    private var lastPhysicsContact: SCNPhysicsContact?

    public init(view: SCNView) {
        super.init()
        self.view = view
        setupWorld()
        setupMainCharacter()
        setupDiffusedLight()
        setupSun()
        setupMusic()
        try! setupOverlay()
        setupPhysics()

        view.pointOfView = mainCharacter.cameraNode
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupWorld() {
        worldManager = WorldManager(20, 20, MainScene.scale)
        world = worldManager.generateWorldNode()
        world.position = SCNVector3(0, 0, 0)

        rootNode.addChildNode(world)
        view?.prepare([try! SCNNode.load(from: "sprout.scn", node: "plant")], completionHandler: nil) // preload sprout node
    }

    private func setupDiffusedLight() {
        diffusedLightNode = SCNNode()
        let light = SCNLight()
        light.type = .ambient
        light.intensity = 400
        diffusedLightNode.light = light

        rootNode.addChildNode(diffusedLightNode)
    }

    private func setupSun() {
        sun = Sun(initialPosition: SCNVector3(60, 300, 60))
        rootNode.addChildNode(sun.lightNode)
    }

    private func setupMainCharacter() {
        mainCharacter = Character(initialPosition: SCNVector3(60, 0, 60), physicsWorld: physicsWorld)
        rootNode.addChildNode(mainCharacter.rootNode)
    }
    
    private func setupMusic() {
        AudioManager.shared.playChillMusic()
    }
    
    private func setupOverlay() throws {
        guard let view = view else { throw MainSceneError.noView }
        overlay = OverlayScene(size: view.bounds.size, delegate: self, growableTrees: worldManager.growableTrees)
        view.overlaySKScene = overlay
    }
    
    private func setupPhysics() {
        physicsWorld.contactDelegate = self
    }
}

// MARK: - Overlay
extension MainScene: JoystickDelegate {
    func positionDidChange(_ joystick: Joystick, distance: CGFloat, alpha: CGFloat) {
        if joystick == overlay.positionJoystick {
            mainCharacter.updateJoystickDirection(distance, alpha: alpha)
        } else if joystick == overlay.cameraJoystick {
            let xDistanceFromCenter = cos(alpha) * distance
            mainCharacter.directionAngle = xDistanceFromCenter * 0.01
        }
    }
}

extension MainScene: ButtonDelegate {
    func didReceiveTap(_ button: Button) {
        if button == overlay.plantSproutButton,
           let tree = lastPhysicsContact?.nodeA as? GrowableTreeNode {
            tree.shouldUpdate = true
            nPhysicsContacts = 0
        }
    }
}

// MARK: - ContactDelegate
extension MainScene: SCNPhysicsContactDelegate {
    public func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        if contact.nodeA.physicsBody?.categoryBitMask == BitMask.character.rawValue ||
            contact.nodeB.physicsBody?.categoryBitMask == BitMask.character.rawValue {
            nPhysicsContacts += 1
            overlay.plantSproutButton.isEnabled = true
            lastPhysicsContact = contact
        }
    }
    
    public func physicsWorld(_ world: SCNPhysicsWorld, didEnd contact: SCNPhysicsContact) {
        if contact.nodeA.physicsBody?.categoryBitMask == BitMask.character.rawValue ||
            contact.nodeB.physicsBody?.categoryBitMask == BitMask.character.rawValue {
            // Everything that enters a closed shape must exit from it. Like happens in the Gauss theorem
            nPhysicsContacts -= 1
        }
    }
}

// MARK: - Render loop
extension MainScene: SCNSceneRendererDelegate {
    public func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        mainCharacter.update()
        worldManager.update(renderer, at: time)
        overlay.update(worldManager.grownTrees)
    }
}
