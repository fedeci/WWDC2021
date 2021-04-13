import Foundation

struct BitMask: OptionSet {
    typealias RawValue = Int
    let rawValue: RawValue

    static let character = BitMask(rawValue: 1 << 0)
    static let world = BitMask(rawValue: 1 << 1)
    static let staticTree = BitMask(rawValue: 1 << 2)
    struct GrowableTree {
        static let empty = BitMask(rawValue: 1 << 3)
        static let tree = BitMask.staticTree
    }
}
