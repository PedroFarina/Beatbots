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
    let music: Music
    init(scene: GameScene, music: Music) {
        self.scene = scene
        self.music = music
        speed = music.speed
        nPlayers = PlayersManager.shared().players.count
        for player in PlayersManager.shared().players {
            if let char = player.selectedCharacter {
                let part = type(of: char).part
                lanes.append(Lane(musicPart: part, player: player, music: music, nextNote: music.getNextNoteFor(part)))
            }
        }
    }

    var waitingNotes: Set<NoteNode> = []
    var timeElapsed: TimeInterval = 0

    private func checkLane(_ nLane: Int) {
        let laneIndex = nLane - 1
        guard let currentNote = lanes[laneIndex].nextNote else {
            return
        }
        if timeElapsed + speed > currentNote.at {
            self.lanes[laneIndex].getNextNote()

            let noteNode = NodePool.getNote(with: currentNote.command)
            let player = self.lanes[laneIndex].player
            noteNode.player = player
            noteNode.part = self.lanes[laneIndex].musicPart
            
            noteNode.position.y = 0.4 - (0.2 * CGFloat(nLane))
            if PlayersManager.shared().players.count == 1 {
                noteNode.position.y -= 0.2
            }
            let actions = SKAction.sequence([
                SKAction.moveTo(x: -0.248, duration: speed),
                SKAction.run {
                    noteNode.isWaiting = true
                    _ = self.lockQueue.sync {
                        self.waitingNotes.insert(noteNode)
                    }
                },
                SKAction.wait(forDuration: lanes[laneIndex].player.controlStyle == .iPhone ?  0.075 : 0.05),
                SKAction.run {
                    let removeAction = SKAction.run {
                        MusicFilePlayer.setVolume(0, on: self.lanes[laneIndex].musicPart)
                        _ = self.lockQueue.sync {
                            self.waitingNotes.remove(noteNode)
                        }
                    }

                    var newActions:[SKAction] = [
                        //fade out
                        SKAction.group([
                            SKAction.moveBy(x: -0.1, y: 0, duration: 0.2),
                            SKAction.fadeOut(withDuration: 0.2)]),
                        //release
                        SKAction.run {
                            NodePool.release(note: noteNode)
                        }
                    ]

                    if GlobalProperties.perfectNotes {
                        newActions.insert(removeAction, at: 0)
                    } else {
                        newActions.insert(removeAction, at: 1)
                    }

                    noteNode.run(SKAction.sequence(newActions))
                }
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

        for note in waitingNotes where note.player?.currentCommand == note.command {
            _ = lockQueue.sync {
                waitingNotes.remove(note)
            }
            note.removeAllActions()
            if let part = note.part {
                MusicFilePlayer.setVolume(1.0, on: part)
                note.player?.points += Double(1 / music.totalNotes[part.getIndex()])
            }
            let newActions = [
                SKAction.resize(toWidth: 0.03, height: 0.03, duration: 0.2),
                SKAction.run({
                    NodePool.release(note: note)
                })
            ]
            note.run(SKAction.sequence(newActions))
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
