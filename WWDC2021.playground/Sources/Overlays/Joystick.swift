import SpriteKit

final class Joystick: SKNode {
    struct Config {
        let outerStrokeColor: UIColor
        let handleColor: UIColor
        let activeHandleColor: UIColor

        init(
            outerStrokeColor: UIColor = .white,
            handleColor: UIColor = .white,
            activeHandleColor: UIColor = .gray
        ) {
            self.outerStrokeColor = outerStrokeColor
            self.handleColor = handleColor
            self.activeHandleColor = activeHandleColor
        }
    }

    weak var delegate: JoystickDelegate?

    private var config: Config!
    private var handleNode: SKShapeNode!
    private var backgroundNode: SKShapeNode!
    private var radius: CGFloat = 50

    init(radius: CGFloat, config: Config = Config()) {
        super.init()
        self.config = config
        self.radius = radius
        setupBackgroundNode()
        setupHandleNode()

        isUserInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupBackgroundNode() {
        backgroundNode = SKShapeNode(circleOfRadius: radius)
        backgroundNode.strokeColor = config.outerStrokeColor
        addChild(backgroundNode)
    }

    private func setupHandleNode() {
        handleNode = SKShapeNode(circleOfRadius: radius / 3)
        handleNode.fillColor = config.handleColor
        addChild(handleNode)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        handleNode.fillColor = config.activeHandleColor
        if let touch = touches.first {
            let location = touch.location(in: self)
            let handleDistanceFromCenter = sqrt(pow(location.x, 2) + pow(location.y, 2))
            let alpha = atan2(location.y, location.x)

            if handleDistanceFromCenter > radius {
                let handleX = (radius * location.x) / handleDistanceFromCenter
                let handleY = (radius * location.y) / handleDistanceFromCenter
                handleNode.position = CGPoint(x: handleX, y: handleY)
            } else {
                handleNode.position = CGPoint(x: location.x, y: location.y)
            }

            let distance = round((sqrt(pow(handleNode.position.x, 2) + pow(handleNode.position.y, 2)) / radius) * 100) / 100
            delegate?.positionDidChange(self, distance: distance, alpha: alpha)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        handleNode.fillColor = config.handleColor
        handleNode.position = CGPoint(x: 0, y: 0)
        delegate?.positionDidChange(self, distance: 0, alpha: 0)
    }
}
