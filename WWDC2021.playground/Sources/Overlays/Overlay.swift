import SpriteKit

typealias OverlayDelegate = JoystickDelegate & ButtonDelegate

final class OverlayScene: SKScene {
    weak var overlayDelegate: OverlayDelegate?
    
    private(set) var positionJoystick: Joystick!
    private(set) var cameraJoystick: Joystick!
    private(set) var plantSproutButton: Button!
    
    private var grownTreesLabelNode: SKLabelNode!
    private var grownTreesSpriteNode: SKSpriteNode!

    private var growableTrees: Int!
    private var grownTrees: Int = 0 {
        didSet {
            grownTreesLabelNode.text = "\(grownTrees)/\(growableTrees ?? 0)"
            if grownTrees == growableTrees {
                // play confetti
            }
        }
    }
    
    init(size: CGSize, delegate: OverlayDelegate, growableTrees: Int) {
        super.init(size: size)
        self.growableTrees = growableTrees
        overlayDelegate = delegate
        
        setupPositionJoystick()
        setupCameraJoystick()
        setupPlantSproutButton()
        
        setupGrownTreesSpriteNode()
        setupGrownTreesLabelNode()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPositionJoystick() {
        let config = Joystick.Config(outerStrokeColor: .black, handleColor: .black)
        positionJoystick = Joystick(radius: 75, config: config)
        positionJoystick.delegate = overlayDelegate
        positionJoystick.position = CGPoint(x: size.width - 100, y: 100)
        addChild(positionJoystick)
    }
    
    private func setupCameraJoystick() {
        let config = Joystick.Config(outerStrokeColor: .black, handleColor: .black)
        cameraJoystick = Joystick(radius: 50, config: config)
        cameraJoystick.delegate = overlayDelegate
        cameraJoystick.position = CGPoint(x: 75, y: 100)
        addChild(cameraJoystick)
    }
    
    private func setupPlantSproutButton() {
        plantSproutButton = Button(CGSize(width: 90, height: 90), imageNamed: "plant_sprout")
        plantSproutButton.delegate = overlayDelegate
        plantSproutButton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        plantSproutButton.position = CGPoint(x: size.width / 2, y: 100)
        plantSproutButton.isEnabled = false
        
        addChild(plantSproutButton)
    }
    
    private func setupGrownTreesSpriteNode() {
        grownTreesSpriteNode = SKSpriteNode(texture: SKTexture(imageNamed: "tree.png"), size: CGSize(width: 40, height: 40))
        grownTreesSpriteNode.anchorPoint = .zero
        grownTreesSpriteNode.position = CGPoint(x: 25, y: size.height - 50)
        addChild(grownTreesSpriteNode)
    }
    
    private func setupGrownTreesLabelNode() {
        grownTreesLabelNode = SKLabelNode(text: "\(grownTrees)/\(String(describing: growableTrees))")
        grownTreesLabelNode.position = CGPoint(x: grownTreesSpriteNode.frame.maxX + 50, y: size.height - 40)
        grownTreesLabelNode.fontName = "MarkerFelt-Wide"
        grownTreesLabelNode.fontColor = UIColor(hex: 0x000000)
        
        addChild(grownTreesLabelNode)
    }
    
    func update(_ grownTrees: Int) {
        self.grownTrees = grownTrees
    }
}
