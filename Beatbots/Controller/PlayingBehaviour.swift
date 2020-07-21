//
//  PlayingBehaviour.swift
//  Beatbots
//
//  Created by Pedro Giuliano Farina on 14/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import SpriteKit

public class PlayingBehaviour: GameBehaviour {
    public var scene: GameScene
    weak var tvControllerPlayer: Player?
    var nodesToRemove: Set<SKSpriteNode> = []
    let music = Music(name: "01")
    lazy var spawner = NoteSpawner(scene: scene, music: music)

    init(scene: GameScene) {
        self.scene = scene
        scene.backgroundNode.texture = SKTexture(imageNamed: GlobalProperties.curtainClosed ? "playBackground2": "playBackground")
        MusicFilePlayer.stopPlaying()
        DispatchQueue.main.async {
            let now = MusicFilePlayer.now()
            MusicFilePlayer.playInBackground(fileName: "01background", ext: ".wav", at: now + self.music.speed)
            MusicFilePlayer.playInPart(fileName: "01", ext: ".wav", part: .Harmony, at: now + self.music.speed)
            MusicFilePlayer.playInPart(fileName: "01", ext: ".wav", part: .Melody, at: now + self.music.speed)
            MusicFilePlayer.playInPart(fileName: "01", ext: ".wav", part: .Rhythm, at: now + self.music.speed)
        }
        makeLanes()
        tvControllerPlayer = PlayersManager.shared().getPlayerFrom(GlobalProperties.tvControllerPlayerID)
    }

    private func makeLanes() {
        var yValue = 0.4
        if PlayersManager.shared().players.count == 1 {
            yValue = 0.2
        }
        for character in PlayersManager.shared().players.map({return $0.selectedCharacter}) {
            yValue -= 0.20
            if let charValue = character {
                let characterNode = SKSpriteNode(imageNamed: type(of: charValue).framePath)
                characterNode.size = CGSize(width: 0.135, height: 0.135)
                characterNode.position = CGPoint(x: -0.4, y: yValue)
                nodesToRemove.insert(characterNode)
                scene.addChild(characterNode)
            }
            let lane = SKSpriteNode(texture: SKTexture(imageNamed: "Lane"))
            nodesToRemove.insert(lane)
            lane.size = CGSize(width: 0.82, height: 0.2)
            lane.position = CGPoint(x: 0.111, y: yValue)
            scene.addChild(lane)
        }
    }

    let threshold: CGFloat = 0.2
    var firstPoint: CGPoint?
    var recognizing = true
    public func touchDown(at pos: CGPoint) {
        recognizing = true
        firstPoint = pos
    }

    public func touchMoved(to pos: CGPoint) {
        checkSwipe(on: pos)
    }

    public func touchUp(at pos: CGPoint) {
        checkSwipe(on: pos)
        guard recognizing else {
            return
        }
        tvControllerPlayer?.currentCommand = .Tap
    }

    private func checkSwipe(on pos: CGPoint) {
        guard recognizing else {
            return
        }
        let movement = pos - (firstPoint ?? CGPoint(x: 0, y: 0))
        let value = max(abs(movement.x), abs(movement.y))
        if value > threshold {
            recognizing = false
            if abs(movement.x) == value {
                if movement.x < 0 {
                    tvControllerPlayer?.currentCommand = .SwipeLeft
                } else {
                    tvControllerPlayer?.currentCommand = .SwipeRight
                }
            } else if abs(movement.y) == value {
                if movement.y < 0 {
                    tvControllerPlayer?.currentCommand = .SwipeDown
                } else {
                    tvControllerPlayer?.currentCommand = .SwipeUp
                }
            }
        }
    }

    public func update(deltaTime: TimeInterval) {
        spawner.update(deltaTime: deltaTime)
        for player in PlayersManager.shared().players {
            player.update(deltaTime: deltaTime)
        }
        if !MusicFilePlayer.isBackgroundPlaying() && scene.childNode(withName: NoteNode.name) == nil {
            MusicFilePlayer.stopPlaying()
            PlayersManager.shared().stateHolder?.setState(to: .GameOver)
        }
    }

    deinit {
        for node in nodesToRemove {
            node.removeFromParent()
        }
    }
}
