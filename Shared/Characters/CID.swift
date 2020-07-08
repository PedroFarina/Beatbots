//
//  CID.swift
//  Beatbots
//
//  Created by Pedro Giuliano Farina on 05/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Foundation

public class CID: Character, ObservableObject {
    public static let name = "CID"
    public static let imagePath = "CID"
    #if os(tvOS)
    @Published public var player: Player?
    #endif
}
