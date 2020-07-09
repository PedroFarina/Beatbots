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
    @Published public private(set) var state: ConnectionStatus = .Searching

    init() {
        MultipeerController.shared().delegate = self
        MultipeerController.shared().startService()
    }

    public func peerDiscovered(_ id: MCPeerID) -> Bool {
        state = .Found(id: id.displayName)
        return true
    }

    public func peerLeft(_ id: MCPeerID) {
        state = .Disconnected(id: id.displayName)
    }

    public func peerJoining(_ id: MCPeerID) {
        state = .Connecting(id: id.displayName)
    }

    public func peerJoined(_ id: MCPeerID) {
        state = .Connected(id: id.displayName)
    }

    public func peerLost(_ id: MCPeerID) {
        state = .Lost(id: id.displayName)
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
