import SpriteKit

protocol JoystickDelegate: class {
    func positionChanged(_ joystick: Joystick, distance: CGFloat, alpha: CGFloat)
}
