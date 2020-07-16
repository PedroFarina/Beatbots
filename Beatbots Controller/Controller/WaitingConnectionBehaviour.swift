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
    public var nextBehaviour: PlayerStateBehaviour?

    init(scene: ControllerScene) {
        self.scene = scene
        for child in scene.children {
            child.removeFromParent()
        }
    }
}
