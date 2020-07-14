//
//  NoteNode.swift
//  Beatbots
//
//  Created by Pedro Giuliano Farina on 14/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import SpriteKit

public class NoteNode: SKNode {
    public private(set) var visualNode: SKSpriteNode
    public private(set) var command: Command

    override convenience init() {
        self.init(command: .Tap)
    }

    init(command: Command) {
        self.command = command
        visualNode = SKSpriteNode()
        visualNode.texture = command.texture
        super.init()
    }

    public func changeCommand(to command: Command) {
        self.command = command
        visualNode.texture = command.texture
    }

    required convenience init?(coder aDecoder: NSCoder) {
        guard let command = aDecoder.decodeObject(forKey: "command") as? Command else {
            self.init()
            return
        }
        self.init(command: command)
    }
}
