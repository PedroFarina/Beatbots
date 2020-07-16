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
        for child in scene.children where child.name != "background" {
            child.removeFromParent()
        }

        rocketNode.size = CGSize(width: 0.3, height: 0.3)
        scene.addChild(rocketNode)
        rocketNode.position.y = -0.05
        let up = SKAction.move(by: CGVector(dx: 0, dy: 0.1), duration: 1)
        let down = SKAction.move(by: CGVector(dx: 0, dy: -0.1), duration: 1)
        rocketNode.run(SKAction.repeatForever(SKAction.sequence([up, down])))
    }

    deinit {
        let rocket = rocketNode
        rocketNode.removeAllActions()
        rocketNode.run(SKAction.sequence([SKAction.moveTo(y: 3, duration: 0.5), SKAction.run {
            rocket.removeFromParent()
        }]))
    }
}
