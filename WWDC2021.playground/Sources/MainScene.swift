import SceneKit

public class MainScene: SCNScene {
    private let generator = TerrainGenerator(20, 20, SCNVector3(20, 35, 20))
    private var light = SCNLight()
    private var timer: Timer?
    private var timerCounter: Int = 0

    public override init() {
        super.init()
        setupTerrain()
        setupLight()
        setupTimer()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTerrain() {
        let node = generator.terrain()
        node.position = SCNVector3(0, 0, 0)

        rootNode.addChildNode(node)
    }

    private func setupLight() {
        let node = SCNNode()
        light.type = .omni

        node.light = light
        node.position = SCNVector3(60, 300, 100)
        rootNode.addChildNode(node)
    }

    private func setupTimer() {
        timer = Timer.scheduledTimer(
            timeInterval: 1,
            target: self,
            selector: #selector(updateLightNode),
            userInfo: nil,
            repeats: true
        )
    }

    /**
     * 1 second (real time) -> 10 minutes
     * - 6AM: 2000K / 605 i
     * - 12AM: 6500K / 1010 i
     * - 6PM: 2000K / 605 i
     * - 12PM: 6500K / 200 i
     */
    @objc private func updateLightNode() {
        timerCounter += 10
        if timerCounter >= 1440 {
            timerCounter = 0 // reset timerCounter on new day
        }

        let isPM = timerCounter > 12 * 60
        if (timerCounter > 0 && timerCounter <= 6 * 60) || (timerCounter > 12 * 60 && timerCounter <= 18 * 60) {
            light.temperature = 6500 - CGFloat(isPM ? timerCounter - 12 * 60 : timerCounter) * 12.5
        } else {
            light.temperature = 2000 + CGFloat(isPM ? timerCounter - 18 * 60 : timerCounter - 6 * 60) * 12.5
        }

        let midnightIntensity: CGFloat = 200
        if timerCounter <= 12 * 60 {
            light.intensity = midnightIntensity + CGFloat(timerCounter) * 1.125
        } else {
            light.intensity = midnightIntensity + (CGFloat(24 * 60 - timerCounter) * 1.125)
        }
    }
}
