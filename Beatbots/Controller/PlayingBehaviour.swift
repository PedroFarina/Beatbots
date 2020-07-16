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
    var characters: [SKSpriteNode] = []
    lazy var spawner = NoteSpawner(scene: scene, music: Music(name: "Teste"))

    init(scene: GameScene) {
        self.scene = scene
        scene.backgroundNode.texture = SKTexture(imageNamed: "playBackground")
        makeCharacters()
        tvControllerPlayer = PlayersManager.shared().getPlayerFrom(GlobalProperties.tvControllerPlayerID)
    }

    private func makeCharacters() {
        var yValue = 0.4
        for character in PlayersManager.shared().players.map({return $0.selectedCharacter}) {
            yValue -= 0.20
            if let charValue = character {
                let characterNode = SKSpriteNode(imageNamed: type(of: charValue).framePath)
                characterNode.size = CGSize(width: 0.135, height: 0.135)
                characterNode.position = CGPoint(x: -0.4, y: yValue)
                characters.append(characterNode)
                scene.addChild(characterNode)
            }
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
    }

    deinit {
        for character in characters {
            character.removeFromParent()
        }
    }
}