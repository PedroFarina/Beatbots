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
        MultipeerController.shared().delegate = self
        tvControllerEnabledChanged(to: GlobalProperties.tvControllerEnabled)
    }

    public var stateHolder: StateHolder?

    public private(set) var players: [Player] = []

    public func getPlayer(from id: String) -> Player? {
        return players.first(where: {$0.id == id})
    }

    public func numberOfPlayer(_ player: Player?) -> String {
        if let index = players.firstIndex(where: {$0.id == player?.id}) {
            return String(index + 1)
        }
        return ""
    }
    public func colorFor(_ player: Player?) -> UIColor {
        let number = numberOfPlayer(player)
        switch number {
        case "1":
            return UIColor.systemRed
        case "2":
            return UIColor.systemGreen
        case "3":
            return UIColor.systemTeal
        default:
            return UIColor.clear
        }
    }

    public func characterSelected(character: Character, by id: String) {
        if let player = players.first(where: {$0.id == id}) {
            player.selectedCharacter?.player = nil
            character.player = player
            player.selectedCharacter = character
        }
    }

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
        tvControllerEnabledChanged(to: GlobalProperties.tvControllerEnabled)
    }

    public func peerJoined(_ id: MCPeerID) {
        if !players.contains(where: {$0.id == id.displayName}) {
            players.append(Player(id: id))
        }
        print(MultipeerController.shared().connectedPeers.count)
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

    public func receivedData(_ data: Data, from peerID: MCPeerID) {
        if let str = String(bytes: data, encoding: .utf8) {
        }
    }
}
