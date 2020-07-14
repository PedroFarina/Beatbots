//
//  MultipeerManager.swift
//  Beatbots Controller
//
//  Created by Pedro Giuliano Farina on 09/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import MultipeerConnectivity
import SwiftUI

public class MultipeerManager: ObservableObject, MultipeerHandler {
    @Published public private(set) var connectionState: ConnectionStatus = .Searching
    @Published public private(set) var characterState: CharacterStatus = .Choosing
    let myQueue = DispatchQueue(label: "MultipeerManager")

    init() {
        MultipeerController.shared().delegate = self
        MultipeerController.shared().startService()
    }

    private func setState(to state: ConnectionStatus) {
        DispatchQueue.main.async {
            self.connectionState = state
        }
    }

    public func peerDiscovered(_ id: MCPeerID) -> Bool {
        setState(to: .Found(id: id.displayName))
        return true
    }

    public func peerLeft(_ id: MCPeerID) {
        guard id == MultipeerController.shared().host else { return }
        for char in ContentView.characters {
            char.reset()
        }
        DispatchQueue.main.async {
            self.characterState = .Choosing
        }
        setState(to: .Disconnected(id: id.displayName))
        MultipeerController.shared().stopService()
        myQueue.asyncAfter(deadline: .now() + 3) {
            self.setState(to: .Searching)
            MultipeerController.shared().startService()
        }
    }

    public func sessionEnded() {
        for char in ContentView.characters {
            char.reset()
        }
    }

    public func peerJoining(_ id: MCPeerID) {
        guard id == MultipeerController.shared().host else { return }
        setState(to: .Connecting(id: id.displayName))
    }

    public func peerJoined(_ id: MCPeerID) {
        guard id == MultipeerController.shared().host else { return }
        setState(to: .Connected(id: id.displayName))
    }

    public func peerLost(_ id: MCPeerID) {
        guard id == MultipeerController.shared().host else { return }
        setState(to: .Lost(id: id.displayName))
    }

    public func receivedData(_ data: Data, from peerID: MCPeerID) {
        if let str = String(bytes: data, encoding: .utf8) {
            DispatchQueue.main.async {
                switch str {
                case GlobalProperties.confirmationKey:
                    self.characterState.toggle()
                case GlobalProperties.startKey:
                    self.characterState = .Playing
                default:
                    break
                }
            }
        }
    }
}

public enum CharacterStatus {
    case Choosing
    case Confirmed
    case Playing

    @inlinable public mutating func toggle() {
        if self == .Choosing {
            self = .Confirmed
        } else if self == .Confirmed {
            self = .Choosing
        }
    }
}

public enum ConnectionStatus {
    case Searching
    case Found(id: String)
    case Connecting(id: String)
    case Connected(id: String)
    case Disconnected(id: String)
    case Lost(id: String)

    func getText() -> String {
        switch self {
        case .Searching:
            return "Searching for host..."
        case .Found(let id):
            return "\(id) was found."
        case .Connecting(let id):
            return "Connecting to \(id)."
        case .Connected(let id):
            return "Connected to \(id)."
        case .Disconnected(let id):
            return "Unable to connect to \(id)."
        case .Lost(let id):
            return "Connection to \(id) was lost."
        }
    }
}
