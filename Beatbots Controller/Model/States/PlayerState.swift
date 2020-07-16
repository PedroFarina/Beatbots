//
//  PlayerStatus.swift
//  Beatbots Controller
//
//  Created by Pedro Giuliano Farina on 16/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Foundation
import CoreGraphics

public enum PlayerState {
    case WaitingConnection
    case Choosing
    case Confirmed
    case Playing

    @inlinable public mutating func toggle() {
        if self == .Choosing {
            self = .Confirmed
        } else if self == .Confirmed {
            self = .Choosing
        }
    }

    func getBehaviour(for scene: ControllerScene) -> PlayerStateBehaviour? {
        switch self {
        case .WaitingConnection:
            return WaitingConnectionBehaviour(scene: scene)
        case .Choosing:
            return ChoosingBehaviour(scene: scene)
        default:
            return nil
        }
    }
}

public protocol PlayerStateBehaviour: class {
    var scene: ControllerScene { get }
    var nextBehaviour: PlayerStateBehaviour? { get }
    func touchDown(at pos: CGPoint)
    func touchMoved(to pos: CGPoint)
    func touchUp(at pos: CGPoint)
}

public extension PlayerStateBehaviour {
    func touchDown(at pos: CGPoint) {
    }
    func touchMoved(to pos: CGPoint) {
    }
    func touchUp(at pos: CGPoint) {
    }
}
