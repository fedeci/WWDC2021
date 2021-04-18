import AVFoundation

enum AudioManagerError: Error {
    case missingFile(String)
}

final class AudioManager: NSObject {
    static let shared = AudioManager()

    private var backgroundPlayer: AVAudioPlayer?
    var volume: Float = 0.2 {
        didSet {
            backgroundPlayer?.setVolume(volume, fadeDuration: 0)
        }
    }

    func playMusic(from filename: String) throws {
        guard let url = Bundle.main.url(forResource: filename, withExtension: nil) else { throw AudioManagerError.missingFile(filename) }

        backgroundPlayer = try AVAudioPlayer(contentsOf: url)
        backgroundPlayer?.stop()
        backgroundPlayer?.volume = volume
        backgroundPlayer?.numberOfLoops = -1
        backgroundPlayer?.prepareToPlay()
        backgroundPlayer?.play()
    }

    func playChillMusic() {
        try! playMusic(from: "White-Clouds.wav")
    }
}
