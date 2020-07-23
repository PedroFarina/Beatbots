//
//  ChoosingBehaviour.swift
//  Beatbots
//
//  Created by Pedro Giuliano Farina on 23/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import SpriteKit

public class ChoosingBehaviour: GameBehaviour {
    public var scene: GameScene
    init(scene: GameScene) {
        self.scene = scene
        scene.backgroundNode.texture = SKTexture(imageNamed: "choosingBackground")
    }
}

