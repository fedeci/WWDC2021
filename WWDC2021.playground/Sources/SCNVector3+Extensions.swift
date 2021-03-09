import SceneKit

extension SCNVector3 {
    func cross(_ v2: SCNVector3) -> SCNVector3 {
        return SCNVector3(y * v2.z - z * v2.y, z * v2.x - x * v2.z, x * v2.y - y * v2.x)
    }

    static func *(lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
        return SCNVector3(lhs.x * rhs.x, lhs.y * rhs.y, lhs.z * rhs.z)
    }

    static func +(lhs: SCNVector3, rhs: SCNVector3) -> SCNVector3 {
        return SCNVector3(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z)
    }
}
