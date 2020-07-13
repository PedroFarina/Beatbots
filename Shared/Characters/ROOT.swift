//
//  ROOT.swift
//  Beatbots
//
//  Created by Pedro Giuliano Farina on 08/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Foundation

public class ROOT: Character, ObservableObject {
    public var isAvailable: Bool = true

    public static let name = "ROOT"
    public static let imagePath = "ROOT"
    #if os(tvOS)
    @Published public var player: Player?
    #endif
}

