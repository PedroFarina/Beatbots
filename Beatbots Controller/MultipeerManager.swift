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
        setState(to: .Disconnected(id: id.displayName))
    }

    public func peerJoining(_ id: MCPeerID) {
        setState(to: .Connecting(id: id.displayName))
    }

    public func peerJoined(_ id: MCPeerID) {
        setState(to: .Connected(id: id.displayName))
    }

    public func peerLost(_ id: MCPeerID) {
        setState(to: .Lost(id: id.displayName))
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
