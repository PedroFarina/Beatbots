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
    public private(set) var cid = CID()
    public private(set) var bimo = BiMO()
    public private(set) var root = ROOT()

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
        if let player = self.players.first(where: {$0.id == id}) {
            if character.player === player {
                player.selectedCharacter?.player = nil
                character.player = nil
                character.isAvailable = true
            } else if character.isAvailable {
                player.selectedCharacter?.isAvailable = true
                player.selectedCharacter?.player = nil
                character.player = player
                player.selectedCharacter = character
                character.isAvailable = false
            }
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

    private func getCharacter(from str: String) -> Character? {
        if str == type(of: cid).name {
            return cid
        } else if str == type(of: bimo).name {
            return bimo
        } else if str == type(of: root).name {
            return root
        }
        return nil
    }

    public func receivedData(_ data: Data, from peerID: MCPeerID) {
        if let str = String(bytes: data, encoding: .utf8) {
            if str.starts(with: GlobalProperties.choosingKey),
                let character = getCharacter(from: String(str.suffix(str.count - GlobalProperties.choosingKey.count))){
                DispatchQueue.main.async {
                    self.characterSelected(character: character, by: peerID.displayName)
                    if character.isAvailable || character.player?.id == peerID.displayName {
                        MultipeerController.shared().sendToPeers(GlobalProperties.confirmationKey, reliably: false, peers: [peerID])
                    }
                }
            }
        }
    }
}
