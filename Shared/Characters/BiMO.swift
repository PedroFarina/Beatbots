//
//  BiMO.swift
//  Beatbots
//
//  Created by Pedro Giuliano Farina on 08/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Foundation

public class BiMO: Character, ObservableObject {
    public var isAvailable: Bool = true

    public static let name = "BiMO"
    public static let imagePath = "BiMO"
    #if os(tvOS)
    @Published public var player: Player?
    #endif

    public func reset() {
        #if os(tvOS)
        player = nil
        #endif
        isAvailable = true
    }
}
