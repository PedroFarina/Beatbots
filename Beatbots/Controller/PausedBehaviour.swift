//
//  PausedBehaviour.swift
//  Beatbots
//
//  Created by Pedro Giuliano Farina on 21/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import SpriteKit

public class PausedBehaviour: GameBehaviour {
    public var scene: GameScene
    public private(set) var playingBehaviour: PlayingBehaviour
    init(scene: GameScene, playingBehaviour: PlayingBehaviour) {
        self.scene = scene
        self.playingBehaviour = playingBehaviour
        MusicFilePlayer.pause()
        scene.isPaused = true
        scene.children.forEach({$0.action(forKey: "moving")?.speed = 0})
    }
}
