//
//  PlayersManager.swift
//  Beatbots
//
//  Created by Pedro Giuliano Farina on 06/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import MultipeerConnectivity

public class PlayersManager: MultipeerHandler {
    public static func shared() -> PlayersManager {
        return sharedInstance
    }
    private static let sharedInstance: PlayersManager = {
        let mc = PlayersManager()
        return mc
    }()
    private init() {
    }

    public var stateHolder: StateHolder?

    public private(set) var players: [Player] = []

    public func tvControllerEnabledChanged(to value: Bool) {
        if value, let player = Player() {
            players.insert(player, at: 0)
        } else {
            if let index = players.firstIndex(where: {$0.id == GlobalProperties.tvControllerPlayerID}) {
                players.remove(at: index)
            }
        }
    }

    public func peerReceivedInvitation(_ id: MCPeerID) -> Bool {
        return players.count < 3
    }

    public func sessionEnded() {
        players.removeAll()
    }

    public func peerJoined(_ id: MCPeerID) {
        if !players.contains(where: {$0.id == id.displayName}) {
            players.append(Player(id: id))
        }
    }
    public func peerLeft(_ id: MCPeerID) {
        if let index = players.firstIndex(where: {$0.id == id.displayName}) {
            if stateHolder?.getState() == GameState.Playing {
                players[index].connected = false
                stateHolder?.setState(to: .Paused)
            } else {
                players.remove(at: index)
            }
        }
    }
}
