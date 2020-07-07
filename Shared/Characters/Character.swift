//
//  Characters.swift
//  Beatbots
//
//  Created by Pedro Giuliano Farina on 05/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

public protocol Character {
    static var imagePath: String { get }
    #if os(tvOS)
    var player: Player? { get }
    #endif
}
