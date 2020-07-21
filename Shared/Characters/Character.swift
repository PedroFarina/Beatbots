//
//  Characters.swift
//  Beatbots
//
//  Created by Pedro Giuliano Farina on 05/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import SwiftUI

public protocol Character: class {
    static var name: String { get }
    static var imagePath: String { get }
    static var framePath: String { get }
    var isAvailable: Bool { get set }
    #if os(tvOS)
    var player: Player? { get set }
    static var part: MusicPart { get }
    #endif
    
    func reset()
}

public enum MusicPart: String {
    case Rhythm = "rhythm"
    case Melody = "melody"
    case Harmony = "harmony"

    func getIndex() -> Int {
        switch self {
        case .Harmony:
            return 0
        case .Melody:
            return 1
        case .Rhythm:
            return 2
        }
    }
}
