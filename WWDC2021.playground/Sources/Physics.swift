import Foundation

struct BitMask: OptionSet {
    typealias RawValue = Int
    let rawValue: RawValue

    static let character = BitMask(rawValue: 1 << 0)
    static let world = BitMask(rawValue: 1 << 1)
    static let tree = BitMask(rawValue: 1 << 2)
}
