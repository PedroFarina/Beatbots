//
//  GameOverBehaviour.swift
//  Beatbots
//
//  Created by Pedro Giuliano Farina on 21/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import SpriteKit

public class GameOverBehaviour: GameBehaviour {
    public var scene: GameScene
    init(scene: GameScene) {
        self.scene = scene
        scene.stopUpdating = false
        if let player = PlayersManager.shared().players.sorted(by: {$0.points > $1.points}).first,
            let character = player.selectedCharacter {
            scene.backgroundNode.texture = SKTexture(imageNamed: "\(type(of: character).name)Background")
        }
    }
}

