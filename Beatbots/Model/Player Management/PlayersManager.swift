//
//  PlayersManager.swift
//  Beatbots
//
//  Created by Pedro Giuliano Farina on 06/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import MultipeerConnectivity

public protocol PlayersObserver: class {
    func playersChangedTo(_ players: [Player])
}

public class PlayersManager: MultipeerHandler, StateObserver {

    public var observers: [PlayersObserver] = []
    public func addObserver(_ observer: PlayersObserver) {
        observers.append(observer)
    }
    public func removeObserver(_ observer: PlayersObserver) {
        if let index = observers.firstIndex(where: { $0 === observer }) {
            observers.remove(at: index)
        }
    }

    private var state: GameState = .StartMenu
    public func stateChangedTo(_ state: GameState) {
        if self.state == .StartMenu && state == .ChoosingCharacters {
            MultipeerController.shared().startService()
        } else if self.state != .Settings && state == .StartMenu {
            MultipeerController.shared().endSession()
            MultipeerController.shared().stopService()
        } else if self.state == .ChoosingCharacters && state == .Playing {
            MultipeerController.shared().sendToAllPeers(GlobalProperties.startKey, reliably: false)
        } else if self.state == .GameOver {
            for player in PlayersManager.shared().players {
                player.totalNotes = 0
                player.correctNotes = 0
            }
            if state == .StartMenu, GlobalProperties.menuMusicEnabled {
                MusicFilePlayer.playInBackground(fileName: "loop", ext: "wav", looped: true)
            }
        }
        
        self.state = state
    }

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

    public private(set) var players: [Player] = [] {
        didSet {
            for observer in observers {
                observer.playersChangedTo(players)
            }
        }
    }
    public var humanPlayers: [Player] {
        return players.filter({$0.isHuman})
    }

    public func createBot() {
        let bot = Player(chanceOfSuccess: 75...90)
        let robots: [Character] = [cid, bimo, root]
        if let first = robots.filter({$0.isAvailable}).randomElement() {
            players.append(bot)
            selectCharacter(character: first, by: bot.id)
        }
    }

    public func getPlayerFrom(_ lane: Int) -> Player? {
        let i = lane - 1
        guard i < players.count else { return nil }
        return players[i]
    }

    public func getPlayerFrom(_ id: String) -> Player? {
        return players.first(where: {$0.id == id})
    }

    public func numberOfPlayer(_ player: Player?) -> Int {
        if let index = players.firstIndex(where: {$0.id == player?.id}) {
            return index + 1
        }
        return -1
    }
    public func numberOfPlayer(_ player: Player?) -> String {
        let number: Int = numberOfPlayer(player)
        if number == -1 { return "" }
        return String(number)
    }

    public func colorFor(_ player: Player?) -> UIColor {
        let number: String = numberOfPlayer(player)
        switch number {
        case "1":
            return #colorLiteral(red: 0.3803921569, green: 0.8980392157, blue: 0.6941176471, alpha: 0.6)
        case "2":
            return #colorLiteral(red: 0.9882352941, green: 0.4549019608, blue: 0.462745098, alpha: 0.6)
        case "3":
            return #colorLiteral(red: 0.2941176471, green: 0.9019607843, blue: 0.9215686275, alpha: 0.6)
        default:
            return UIColor.clear
        }
    }

    public func selectCharacter(character: Character, by id: String) {
        if let player = getPlayerFrom(id) {
            DispatchQueue.main.async {
                player.selectedCharacter?.isAvailable = true
                player.selectedCharacter?.player = nil
                character.player = player
                player.selectedCharacter = character
                character.isAvailable = false
            }
        }
    }

    public func deselectCharacter(character: Character) {
        DispatchQueue.main.async {
            character.player?.selectedCharacter = nil
            character.player = nil
            character.isAvailable = true
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
        if state == GameState.ChoosingCharacters {
            return players.count < 3
        } else if state == GameState.Paused {
            return getPlayerFrom(id.displayName) != nil
        }
        return false
    }

    public func sessionEnded() {
        players.removeAll()
        cid.reset()
        root.reset()
        bimo.reset()
        
        tvControllerEnabledChanged(to: GlobalProperties.tvControllerEnabled)
    }

    public func peerJoined(_ id: MCPeerID) {
        if !players.contains(where: {$0.id == id.displayName}) {
            players.append(Player(id: id))
        } else if let player = getPlayerFrom(id.displayName),
            let character = player.selectedCharacter {
            player.connected = true
            MultipeerController.shared().sendToPeers(
                "\(GlobalProperties.startKey)\(type(of:character).name)", reliably: false, peers: [id])
            if players.count == 1 {
                stateHolder?.setState(to: .Playing)
            }
        }
        MultipeerController.shared().sendToPeers("\(players.firstIndex(where: {$0.id == id.displayName}) ?? -1)Light", reliably: true, peers: [id])
    }

    public func peerLeft(_ id: MCPeerID) {
        if let index = players.firstIndex(where: {$0.id == id.displayName}) {
            if state == GameState.Playing {
                players[index].connected = false
                stateHolder?.setState(to: .Paused)
            } else {
                if let char = players[index].selectedCharacter {
                    deselectCharacter(character: char)
                } else if let player = players.first(where: {$0.selectedCharacter != nil}),
                    let char = player.selectedCharacter {
                    deselectCharacter(character: char)
                    selectCharacter(character: char, by: player.id)
                }
                players.remove(at: index)
                for player in players {
                    if let id = MultipeerController.shared().connectedPeers.first(where: {$0.displayName == player.id}) {
                        MultipeerController.shared().sendToPeers("\(players.firstIndex(where: {$0.id == id.displayName}) ?? -1)Light", reliably: true, peers: [id])
                    }
                }
            }
        }
    }

    public func getDisconnectedPlayers() -> [Player] {
        var disconnectedPlayers: [Player] = []
        for player in players where !player.connected {
            disconnectedPlayers.append(player)
        }
        return disconnectedPlayers
    }

    public func removeDisconnectedPlayers() {
        while let index = players.firstIndex(where: {!$0.connected}) {
            players[index].selectedCharacter?.player = nil
            players.remove(at: index)
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
            if let command = Command(rawValue: str),
                let player = getPlayerFrom(peerID.displayName) {
                player.currentCommand = command
            } else if str.starts(with: GlobalProperties.selectKey),
                let character = getCharacter(from: String(str.suffix(str.count - GlobalProperties.selectKey.count))){
                DispatchQueue.main.async {
                    if character.isAvailable {
                        self.selectCharacter(character: character, by: peerID.displayName)
                        MultipeerController.shared().sendToPeers(GlobalProperties.confirmationKey, reliably: false, peers: [peerID])
                    }
                }
            } else if str.starts(with: GlobalProperties.deselectKey) {
                DispatchQueue.main.async {
                    if let player = self.getPlayerFrom(peerID.displayName),
                        let character = player.selectedCharacter {
                        self.deselectCharacter(character: character)
                        MultipeerController.shared().sendToPeers(GlobalProperties.confirmationKey, reliably: false, peers: [peerID])
                    }
                }
            }
        }
    }
}
