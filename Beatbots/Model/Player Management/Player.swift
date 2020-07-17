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
    public var currentCommand: Command?

    public let commandTimeOut: TimeInterval
    public private(set) var commandCountdown: TimeInterval

    init?() {
        guard GlobalProperties.tvControllerEnabled else {
            return nil
        }
        id = GlobalProperties.tvControllerPlayerID
        commandTimeOut = 0.25
        commandCountdown = commandTimeOut
    }
    init(id: MCPeerID) {
        self.id = id.displayName
        commandTimeOut = 0.32
        commandCountdown = commandTimeOut
    }

    func update(deltaTime: TimeInterval) {
        if currentCommand == nil { return }
        commandCountdown -= deltaTime
        guard commandCountdown <= 0 else {
            return
        }
        commandCountdown = commandTimeOut
        currentCommand = nil
    }
}
