import SpriteKit

typealias OverlayDelegate = JoystickDelegate & ButtonDelegate

final class OverlayScene: SKScene {
    weak var overlayDelegate: OverlayDelegate?
    
    private var joystick: Joystick!
    private(set) var plantSproutButton: Button!
    
    init(size: CGSize, delegate: OverlayDelegate) {
        super.init(size: size)
        overlayDelegate = delegate
        setupJoystick()
        setupPlantSproutButton()
    }
    
    private func setupJoystick() {
        let config = Joystick.Config(outerStrokeColor: .black, handleColor: .black)
        joystick = Joystick(radius: 75, config: config)
        joystick.delegate = overlayDelegate
        joystick.position = CGPoint(x: size.width - 100, y: 100)
        addChild(joystick)
    }
    
    private func setupPlantSproutButton() {
        plantSproutButton = Button(CGSize(width: 40, height: 40), sfSymbol: "leaf.fill", color: .gray)
        plantSproutButton.delegate = overlayDelegate
        plantSproutButton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        plantSproutButton.position = CGPoint(x: size.width / 2, y: 100)
        plantSproutButton.isEnabled = false
        
        addChild(plantSproutButton)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
