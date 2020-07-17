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
        let index: Int
        switch self {
        case .SwipeUp:
            index = 0
        case .SwipeRight:
            index = 1
        case .SwipeDown:
            index = 2
        case .SwipeLeft:
            index = 3
        case .Tap:
            index = 4
        }
        return Command.textures[index]
    }
    private static let textures: [SKTexture] = [SKTexture(imageNamed: "SwipeUp"), SKTexture(imageNamed: "SwipeRight"), SKTexture(imageNamed: "SwipeDown"), SKTexture(imageNamed: "SwipeLeft"), SKTexture(imageNamed: "Tap")]
    #endif
}
