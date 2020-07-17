//
//  CID.swift
//  Beatbots
//
//  Created by Pedro Giuliano Farina on 05/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Foundation

public class CID: Character, ObservableObject {
    public var isAvailable: Bool = true

    public static let part = MusicPart.Melody
    public static let name = "CID"
    public static let imagePath = "CID"
    public static let framePath = "Frame CID"
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
