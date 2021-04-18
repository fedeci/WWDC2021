import SpriteKit

typealias OverlayDelegate = JoystickDelegate & ButtonDelegate

final class OverlayScene: SKScene {
    weak var overlayDelegate: OverlayDelegate?
    
    private(set) var positionJoystick: Joystick!
    private(set) var cameraJoystick: Joystick!
    private(set) var plantSproutButton: Button!
    
    init(size: CGSize, delegate: OverlayDelegate) {
        super.init(size: size)
        overlayDelegate = delegate
        setupPositionJoystick()
        setupCameraJoystick()
        setupPlantSproutButton()
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
        plantSproutButton = Button(CGSize(width: 40, height: 40), sfSymbol: "leaf.fill", color: .gray)
        plantSproutButton.delegate = overlayDelegate
        plantSproutButton.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        plantSproutButton.position = CGPoint(x: size.width / 2, y: 100)
        plantSproutButton.isEnabled = false
        
        addChild(plantSproutButton)
    }
}
