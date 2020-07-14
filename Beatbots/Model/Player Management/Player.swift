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
    public var currentCommand: Command? {
        didSet {
            print(currentCommand)
        }
    }

    public let commandTimeOut: TimeInterval = 0.25
    public private(set) var commandCountdown: TimeInterval = 0.25

    init?() {
        guard GlobalProperties.tvControllerEnabled else {
            return nil
        }
        id = GlobalProperties.tvControllerPlayerID
    }
    init(id: MCPeerID) {
        self.id = id.displayName
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
