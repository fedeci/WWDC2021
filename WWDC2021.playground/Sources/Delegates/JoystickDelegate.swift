import SpriteKit

protocol JoystickDelegate: class {
    func positionDidChange(_ joystick: Joystick, distance: CGFloat, alpha: CGFloat)
}
