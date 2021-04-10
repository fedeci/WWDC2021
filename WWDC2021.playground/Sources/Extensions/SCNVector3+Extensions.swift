import SceneKit

extension SCNVector3 {
    var length: Float {
        return sqrtf(x * x + y * y + z * z)
    }
    
    var normalized: SCNVector3 {
        return SCNVector3(x / length, y / length, z / length)
    }

    func cross(_ v2: Self) -> Self {
        return SCNVector3(y * v2.z - z * v2.y, z * v2.x - x * v2.z, x * v2.y - y * v2.x)
    }
    
    func dot(_ v2: Self) -> Float {
        return x * v2.x + y * v2.y + z * v2.z
    }
    
    static func * (lhs: Self, rhs: Self) -> Self {
        return SCNVector3(lhs.x * rhs.x, lhs.y * rhs.y, lhs.z * rhs.z)
    }
    
    static func * (lhs: Self, rhs: Float) -> Self {
        return SCNVector3(lhs.x * rhs, lhs.y * rhs, lhs.z * rhs)
    }

    static func + (lhs: Self, rhs: Self) -> Self {
        return SCNVector3(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z)
    }
    
    static func - (lhs: Self, rhs: Self) -> Self {
        return SCNVector3(lhs.x - rhs.x, lhs.y - rhs.y, lhs.z - rhs.z)
    }
}
