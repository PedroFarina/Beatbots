//
//  MusicReader.swift
//  Beatbots
//
//  Created by Pedro Giuliano Farina on 15/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import SpriteKit

public class NoteSpawner {
    private var scene: GameScene
    private let lockQueue = DispatchQueue(label: "NoteSpawnerLocker")
    let speed: TimeInterval
    private var lanes: [Lane] = []
    private var nPlayers: Int
    init(scene: GameScene, music: Music) {
        self.scene = scene
        speed = music.speed
        nPlayers = PlayersManager.shared().players.count
        for player in PlayersManager.shared().players {
            if let char = player.selectedCharacter {
                let part = type(of: char).part
                lanes.append(Lane(musicPart: part, player: player, music: music, nextNote: music.getNextNoteFor(part)))
            }
        }
    }

    var timeElapsed: TimeInterval = 0

    private func checkLane(_ lane: Int) {
        guard let currentNote = lanes[lane - 1].nextNote else {
            return
        }
        if timeElapsed + speed > currentNote.at {
            self.lanes[lane - 1].getNextNote()

            let noteNode = NodePool.getNote(with: currentNote.command)
            noteNode.position.y = 0.4 - (0.2 * CGFloat(lane))
            let actions = SKAction.sequence([
                SKAction.moveTo(x: -0.248, duration: speed),
                SKAction.wait(forDuration: 0.05),
                SKAction.run({
                    let newActions: [SKAction]
                    let release = SKAction.run {
                        NodePool.release(note: noteNode)
                    }
                    let player = self.lanes[lane - 1].player
                    if player.currentCommand == noteNode.command {
                        newActions = [SKAction.resize(toWidth: 0.03, height: 0.03, duration: 0.2), release]
                    } else {
                        newActions = [
                         SKAction.group([
                            SKAction.moveBy(x: -0.1, y: 0, duration: 0.2),
                            SKAction.fadeOut(withDuration: 0.2)]),
                         SKAction.run {
                            NodePool.release(note: noteNode)
                         }
                      ]
                    }
                    noteNode.run(SKAction.sequence(newActions))
                })
            ])
            noteNode.run(actions)
            lockQueue.sync {
                scene.addChild(noteNode)
            }
        }
    }
    public func update(deltaTime: TimeInterval) {
        timeElapsed += deltaTime
        DispatchQueue.concurrentPerform(iterations: nPlayers) { (i) in
            let lane = i + 1
            self.checkLane(lane)
        }
    }
}


struct Lane {
    var musicPart: MusicPart
    var player: Player
    var music: Music
    var nextNote: Note?

    public mutating func getNextNote() {
        nextNote = music.getNextNoteFor(musicPart)
    }
}
