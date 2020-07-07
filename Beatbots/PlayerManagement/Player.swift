//
//  Player.swift
//  Beatbots
//
//  Created by Pedro Giuliano Farina on 06/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import MultipeerConnectivity

public class Player {

    public let id: String
    public var connected: Bool = true
    public var selectedCharacter: Character?

    init?() {
        guard GlobalProperties.tvControllerEnabled else {
            return nil
        }
        id = GlobalProperties.tvControllerPlayerID
    }
    init(id: MCPeerID) {
        self.id = id.displayName
    }
}
