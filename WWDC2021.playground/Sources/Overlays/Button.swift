import SpriteKit

final class Button: SKSpriteNode {
    weak var delegate: ButtonDelegate?
    
    var isEnabled: Bool = true {
        didSet {
            alpha = isEnabled ? 1.0 : 0.7
            isUserInteractionEnabled = isEnabled
        }
    }

    init(_ size: CGSize, sfSymbol name: String, color: UIColor) {
        let configuration = UIImage.SymbolConfiguration(pointSize: 64, weight: .bold)
        let pngData = UIImage(systemName: name, withConfiguration: configuration)!.withTintColor(color).pngData()
        let texture = SKTexture(image: UIImage(data: pngData!)!)
        super.init(texture: texture, color: .clear, size: size)

        setupNode()
    }
    
    init(_ size: CGSize, imageNamed name: String) {
        let texture = SKTexture(imageNamed: name)
        super.init(texture: texture, color: .clear, size: size)

        setupNode()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupNode() {
        anchorPoint = CGPoint(x: 0, y: 0)
        isEnabled = true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        delegate?.didReceiveTap(self)
    }
}
