//
//  WaitingConnectionBehaviour.swift
//  Beatbots Controller
//
//  Created by Pedro Giuliano Farina on 16/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import SpriteKit

public class WaitingConnectionBehaviour: PlayerStateBehaviour {
    public var scene: ControllerScene
    var rocketNode = SKSpriteNode(texture: SKTexture(imageNamed: "searchingRocket"))
    public var nextBehaviour: PlayerStateBehaviour?

    init(scene: ControllerScene) {
        self.scene = scene
    }

    public func setup() {
        ThreadSafeController.resetScene(scene, exceptions: [])

        rocketNode.size = CGSize(width: 0.3, height: 0.3)
        ThreadSafeController.add(rocketNode, to: scene)
        rocketNode.position.y = -0.05
        let up = SKAction.move(by: CGVector(dx: 0, dy: 0.1), duration: 1)
        let down = SKAction.move(by: CGVector(dx: 0, dy: -0.1), duration: 1)
        rocketNode.run(SKAction.repeatForever(SKAction.sequence([up, down])))
    }
}
