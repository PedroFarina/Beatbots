//
//  CID.swift
//  Beatbots
//
//  Created by Pedro Giuliano Farina on 05/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Foundation

public struct CID: Character {
    public static let imagePath: String = "CID"
    #if os(tvOS)
    public var player: Player?
    #endif
    
}
