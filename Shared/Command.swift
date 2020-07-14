//
//  Command.swift
//  Beatbots
//
//  Created by Pedro Giuliano Farina on 08/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

#if os(tvOS)
import SpriteKit
#endif

public enum Command: String {
    case SwipeUp
    case SwipeRight
    case SwipeDown
    case SwipeLeft
    case Tap

    #if os(tvOS)
    public var texture: SKTexture? {
        return Command.textures[self.rawValue]
    }
    private static let textures: [String:SKTexture] = ["SwipeUp":SKTexture(imageNamed: "SwipeUp"), "SwipeRight":SKTexture(imageNamed: "SwipeRight"), "SwipeDown":SKTexture(imageNamed: "SwipeDown"), "SwipeLeft":SKTexture(imageNamed: "SwipeLeft"), "Tap":SKTexture(imageNamed: "Tap")]
    #endif
}
