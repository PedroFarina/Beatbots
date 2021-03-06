//
//  NoteNode.swift
//  Beatbots
//
//  Created by Pedro Giuliano Farina on 14/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import SpriteKit

public class NoteNode: SKSpriteNode {
    public static let name = "NoteNode"
    public private(set) var command: Command
    public weak var player: Player?
    public var part: MusicPart?
    public var isWaiting: Bool = false

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
        self.name = NoteNode.name
    }

    public func changeCommand(to command: Command) {
        self.command = command
        texture = command.texture
    }

    public func reset() {
        position = CGPoint(x: 1.1, y: 0)
        size =  CGSize(width: 0.08, height: 0.08)
        alpha = 1
        removeAllActions()
        isWaiting = false
        player = nil
        part = nil
    }

    required convenience init?(coder aDecoder: NSCoder) {
        guard let command = aDecoder.decodeObject(forKey: "command") as? Command else {
            self.init()
            return
        }
        self.init(command: command)
    }
}
