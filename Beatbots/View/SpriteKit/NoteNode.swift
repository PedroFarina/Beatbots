//
//  NoteNode.swift
//  Beatbots
//
//  Created by Pedro Giuliano Farina on 14/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import SpriteKit

public class NoteNode: SKSpriteNode {
    public private(set) var command: Command

    convenience init() {
        self.init(command: .Tap)
    }

    init(command: Command) {
        self.command = command
        if let texture = command.texture {
            super.init(texture: texture, color: .clear, size: CGSize(width: 0.08, height: 0.083))
        } else {
            super.init(texture: nil, color: .red, size: CGSize(width: 0.5, height: 0.5))
        }
        position = CGPoint(x: 1.1, y: 0)
    }

    public func changeCommand(to command: Command) {
        self.command = command
        texture = command.texture
    }

    public func reset() {
        position = CGPoint(x: 1.1, y: 0)
        removeAllActions()
    }

    required convenience init?(coder aDecoder: NSCoder) {
        guard let command = aDecoder.decodeObject(forKey: "command") as? Command else {
            self.init()
            return
        }
        self.init(command: command)
    }
}
