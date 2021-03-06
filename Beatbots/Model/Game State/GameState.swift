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

public extension GameBehaviour {
    func touchDown(at pos: CGPoint) {}
    func touchMoved(to pos: CGPoint) {}
    func touchUp(at pos: CGPoint) {}
    func update(deltaTime: TimeInterval) {}
}

public enum GameState {
    case StartMenu
    case Settings
    case ChoosingCharacters
    case Tutorial
    case Playing
    case Paused
    case GameOver

    func behaviour(on scene: GameScene) -> GameBehaviour? {
        switch self {
        case .StartMenu:
            return StartMenuBehaviour(scene: scene)
        case .ChoosingCharacters:
            return ChoosingBehaviour(scene: scene)
        case  .Tutorial:
            return TutorialBehaviour(scene: scene)
        case .Playing:
            return PlayingBehaviour(scene: scene)
        case  .Paused:
            if let behaviour = scene.behaviour as? PlayingBehaviour {
                return PausedBehaviour(scene: scene, playingBehaviour: behaviour)
            }
            return nil
        case .GameOver:
            return GameOverBehaviour(scene: scene)
        default:
            return nil
        }
    }
}
