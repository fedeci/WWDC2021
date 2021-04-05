import SpriteKit

typealias OverlayDelegate = JoystickDelegate

final class OverlayScene: SKScene {
    weak var overlayDelegate: OverlayDelegate?
    
    private var joystick: Joystick!
    
    init(size: CGSize, delegate: OverlayDelegate) {
        super.init(size: size)
        overlayDelegate = delegate
        setupJoystick()
    }
    
    private func setupJoystick() {
        let config = Joystick.Config(outerStrokeColor: .black, handleColor: .black)
        joystick = Joystick(radius: 75, config: config)
        joystick.delegate = overlayDelegate
        joystick.position = CGPoint(x: size.width - 100, y: 100)
        addChild(joystick)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
