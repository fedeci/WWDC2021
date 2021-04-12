import Foundation

extension TimeInterval {
    var seconds: Int {
        return Int(self) % 60
    }
}
