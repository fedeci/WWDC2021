import SceneKit

extension SCNVector3 {
    static func * (lhs: Self, rhs: Self) -> Self {
        return SCNVector3(lhs.x * rhs.x, lhs.y * rhs.y, lhs.z * rhs.z)
    }

    static func + (lhs: Self, rhs: Self) -> Self {
        return SCNVector3(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z)
    }
}
