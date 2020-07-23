//
//  MainMenuBehaviour.swift
//  Beatbots
//
//  Created by Pedro Giuliano Farina on 16/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import SpriteKit

public class StartMenuBehaviour: GameBehaviour {
    public var scene: GameScene
    init(scene: GameScene) {
        self.scene = scene
        scene.stopUpdating = false
        scene.backgroundNode.texture = SKTexture(imageNamed: "startBackground")
        scene.children.forEach({if $0 != scene.backgroundNode { $0.removeAllActions(); $0.removeFromParent() }})
    }
}
