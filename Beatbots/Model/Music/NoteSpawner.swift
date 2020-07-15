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
    init(scene: GameScene, music: Music) {
        self.scene = scene
        speed = music.speed
        for i in 1...3 {
            lanes.append(Lane(num: i, music: music, nextNote: music.getNextNoteFor(i)))
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
                SKAction.moveTo(x: -0.243, duration: speed),
                SKAction.run({
                    NodePool.release(note: noteNode)
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
        DispatchQueue.concurrentPerform(iterations: 3) { (i) in
            let lane = i + 1
            self.checkLane(lane)
        }
    }
}


struct Lane {
    var num: Int
    var music: Music
    var nextNote: Note?
    public mutating func getNextNote() {
        nextNote = music.getNextNoteFor(num)
    }
}
