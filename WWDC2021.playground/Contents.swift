import PlaygroundSupport
import SceneKit

let sceneView = SCNView(frame: CGRect(x: 0, y: 0, width: 640, height: 480))
let scene = MainScene(view: sceneView)
sceneView.scene = scene

PlaygroundPage.current.liveView = sceneView

sceneView.showsStatistics = true
sceneView.allowsCameraControl = true
