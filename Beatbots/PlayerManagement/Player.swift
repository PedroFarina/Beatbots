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
            if currentCommand == nil {
                alreadyNil = true
            } else {
                alreadyNil = false
            }
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

    var alreadyNil: Bool = false
    func update(deltaTime: TimeInterval) {
        if alreadyNil { return }
        commandCountdown -= deltaTime
        guard commandCountdown <= 0 else {
            return
        }
        commandCountdown = commandTimeOut
        currentCommand = nil
    }
}
