//
//  FrameNode.swift
//  Beatbots Controller
//
//  Created by Pedro Giuliano Farina on 21/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import SpriteKit

public class FrameNode: SKSpriteNode {
    public var character: Character

    convenience init() {
        self.init(character: BiMO())
    }

    init(character: Character) {
        self.character = character
        let texture = SKTexture(imageNamed: type(of: character).framePath)
        super.init(texture: texture, color: .clear, size: CGSize(width: 0.3, height: 0.3))
    }

    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }
}
