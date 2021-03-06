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
    var charactersNodes: [FrameNode] = []
    var lanes: [SKSpriteNode] = []
    let music = Music(name: "01")
    var spawner: NoteSpawner

    init(scene: GameScene) {
        self.scene = scene
        scene.stopUpdating = false
        spawner = NoteSpawner(scene: scene, music: music)
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

    public func resume() {
        MusicFilePlayer.setVolume(1, on: .Harmony)
        MusicFilePlayer.setVolume(1, on: .Rhythm)
        MusicFilePlayer.setVolume(1, on: .Melody)
        PlayersManager.shared().removeDisconnectedPlayers()

        spawner.recalculatePlayers()
        spawner.recalculateTimeWith(music.speed)

        lanes.forEach({$0.removeFromParent()})
        charactersNodes.forEach({$0.removeFromParent()})
        makeLanes()

        let now = MusicFilePlayer.now()
        MusicFilePlayer.resume(in: now + 1.5)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.scene.stopUpdating = false
            self.scene.children.forEach({
                if let action = $0.action(forKey: "moving") {
                    action.speed = 1
                    $0.zPosition = 999
                }
            })
        }
    }

    private func makeLanes() {
        var yValue = 0.4
        for character in PlayersManager.shared().players.map({return $0.selectedCharacter}) {
            yValue -= 0.20
            if let charValue = character {
                let characterNode = FrameNode(character: charValue)
                charValue.player?.frame = characterNode
                characterNode.size = CGSize(width: 0.135, height: 0.135)
                characterNode.position = CGPoint(x: -0.4, y: yValue)
                charactersNodes.append(characterNode)
                scene.addChild(characterNode)
            }
            let lane = SKSpriteNode(texture: SKTexture(imageNamed: "Lane"))
            lanes.append(lane)
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

    var totalTime: TimeInterval = 0
    public func update(deltaTime: TimeInterval) {
        spawner.update(deltaTime: deltaTime)
        for player in PlayersManager.shared().players {
            player.update(deltaTime: deltaTime)
        }
        totalTime += deltaTime
        guard totalTime > music.speed else  {
            return
        }
        if !MusicFilePlayer.isBackgroundPlaying() && scene.childNode(withName: NoteNode.name) == nil {
            MusicFilePlayer.stopPlaying()
            PlayersManager.shared().stateHolder?.setState(to: .GameOver)
        }
    }

    deinit {
        for node in lanes {
            node.removeFromParent()
        }
        for node in charactersNodes {
            node.removeFromParent()
        }
        scene.stopUpdating = false
    }
}
