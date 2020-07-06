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

    init(id: MCPeerID) {
        self.id = id.displayName
    }
}
