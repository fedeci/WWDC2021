import SpriteKit

final class Button: SKSpriteNode {
    weak var delegate: ButtonDelegate?
    
    init(_ size: CGSize, sfSymbol name: String, color: UIColor) {
        let configuration = UIImage.SymbolConfiguration(pointSize: 64, weight: .bold)
        let pngData = UIImage(named: name, in: nil, with: configuration)!.withTintColor(color).pngData()
        let texture = SKTexture(image: UIImage(data: pngData!)!)

        super.init(texture: texture, color: .clear, size: size)
        setupNode()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupNode() {
        anchorPoint = CGPoint(x: 0, y: 0)
        isUserInteractionEnabled = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        delegate?.receivedTap(self)
    }
}
