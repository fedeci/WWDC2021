import SceneKit
import Combine

final class Sun: NSObject {
    private(set) var lightNode: SCNNode!
    private var cancellable: Cancellable?
    
    /**
     * 1 second (real time) -> 10 minutes
     * - 6AM: 2000K / 605 i
     * - 12AM: 6500K / 1010 i
     * - 6PM: 2000K / 605 i
     * - 12PM: 6500K / 200 i
     */
    private var timerCounter = 0 {
        didSet {
            if timerCounter >= 1440 {
                timerCounter = 0 // reset timerCounter on new day
                return
            }

            let isPM = timerCounter > 12 * 60
            if (timerCounter > 0 && timerCounter <= 6 * 60) || (timerCounter > 12 * 60 && timerCounter <= 18 * 60) {
                temperature = 6500 - CGFloat(isPM ? timerCounter - 12 * 60 : timerCounter) * 12.5
            } else {
                temperature = 2000 + CGFloat(isPM ? timerCounter - 18 * 60 : timerCounter - 6 * 60) * 12.5
            }

            let midnightIntensity: CGFloat = 200
            if timerCounter <= 12 * 60 {
                intensity = midnightIntensity + CGFloat(timerCounter) * 1.125
            } else {
                intensity = midnightIntensity + (CGFloat(24 * 60 - timerCounter) * 1.125)
            }
        }
    }

    private(set) var temperature: CGFloat {
        get { lightNode.light!.temperature }
        set { lightNode.light!.temperature = newValue }
    }

    private(set) var intensity: CGFloat {
        get { lightNode.light!.intensity }
        set { lightNode.light!.intensity = newValue }
    }

    init(initialPosition position: SCNVector3) {
        super.init()
        setupLightNode(initialPosition: position)
        setupTimer()
    }
    
    deinit {
        cancellable?.cancel()
    }

    private func setupLightNode(initialPosition position: SCNVector3) {
        lightNode = SCNNode()
        let light = SCNLight()
        light.type = .omni

        lightNode.position = position
        lightNode.light = light
    }

    private func setupTimer() {
        cancellable = Timer.publish(every: 0.2, on: RunLoop.main, in: RunLoop.Mode.default)
            .autoconnect()
            .sink(receiveValue: { [weak self] _ in
                self?.timerCounter += 2
            })
    }
}
