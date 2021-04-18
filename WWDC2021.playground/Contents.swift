// Instructions:
// - Use the left joystick to move the camera and set the direction of the character
// - Use the right joystick to move the character
// - Plant a sprout on the brown spots of soil using the button in the middle
// - Plant trees in all the available spots to complete the game

import PlaygroundSupport
import SceneKit

let sceneView = SCNView(frame: CGRect(x: 0, y: 0, width: 640, height: 480))
let scene = MainScene(view: sceneView)
sceneView.scene = scene
sceneView.delegate = scene

PlaygroundPage.current.liveView = sceneView
