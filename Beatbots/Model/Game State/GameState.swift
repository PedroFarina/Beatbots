//
//  GameState.swift
//  Beatbots
//
//  Created by Pedro Giuliano Farina on 03/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Foundation
import CoreGraphics

public protocol GameBehaviour: class {
    var scene: GameScene { get set }
    func touchDown(at pos: CGPoint)
    func touchMoved(to pos: CGPoint)
    func touchUp(at pos: CGPoint)
    func update(deltaTime: TimeInterval)
}

public enum GameState {
    case StartMenu
    case Config
    case ChoosingCharacters
    case Playing
    case Paused
    case GameOver

    func behaviour(on scene: GameScene) -> GameBehaviour? {
        switch self {
        case .Playing:
            return PlayingBehaviour(scene: scene)
        default:
            return nil
        }
    }
}
