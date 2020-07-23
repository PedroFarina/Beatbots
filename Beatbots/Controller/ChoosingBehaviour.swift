//
//  ChoosingBehaviour.swift
//  Beatbots
//
//  Created by Pedro Giuliano Farina on 23/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import SpriteKit

public class ChoosingBehaviour: GameBehaviour, PlayersObserver {

    private var lightsNode: [SKSpriteNode] = []
    public var scene: GameScene
    init(scene: GameScene) {
        self.scene = scene
        PlayersManager.shared().addObserver(self)
        scene.stopUpdating = false
        scene.backgroundNode.texture = SKTexture(imageNamed: "choosingBackground")
        var x: CGFloat = -0.072
        for i in 0...2 {
            let texture = SKTexture(imageNamed: "\(i)Light")
            let light = SKSpriteNode(texture: texture)
            light.size = CGSize(width: 0.12, height: 0.125)
            light.position.y = 0.2225
            light.position.x = x
            x += 0.073
            lightsNode.append(light)
        }
        if GlobalProperties.tvControllerEnabled {
            let texture = SKTexture(imageNamed: "tvController")
            let controller = SKSpriteNode(texture: texture)
            controller.size = CGSize(width: 0.01, height: 0.025)
            lightsNode[0].addChild(controller)
        }
        showLights()
    }

    public func playersChangedTo(_ players: [Player]) {
        showLights()
    }

    private func showLights() {
        let playersCount = PlayersManager.shared().players.count
        for i in 0 ..< lightsNode.count {
            if i < playersCount {
                if lightsNode[i].parent == nil {
                    scene.addChild(lightsNode[i])
                }
            } else {
                lightsNode[i].removeFromParent()
            }
        }
    }

    deinit {
        for light in lightsNode {
            light.removeFromParent()
        }
    }
}

