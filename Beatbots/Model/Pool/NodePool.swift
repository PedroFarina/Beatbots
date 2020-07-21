//
//  NodePool.swift
//  Beatbots
//
//  Created by Pedro Giuliano Farina on 14/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import SpriteKit

public class NodePool {
    private static let lockQueue = DispatchQueue(label: "node.pool")
    private static var notes: Pool<NoteNode> = Pool([])

    public static func start() {

    }
    public static func getNote(with command: Command) -> NoteNode {
        if let next = notes.acquire() {
            next.changeCommand(to: command)
            return next
        } else {
            defer {
                lockQueue.async {
                    for _ in 1 ... 50 {
                        release(note: NoteNode())
                    }
                }
            }
            return NoteNode(command: command)
        }
    }
    public static func release(note: NoteNode) {
        note.reset()
        note.removeFromParent()
        notes.release(note)
    }
}

