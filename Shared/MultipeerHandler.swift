//
//  MultipeerHandler.swift
//  Beatbots
//
//  Created by Pedro Giuliano Farina on 06/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import MultipeerConnectivity

public protocol MultipeerHandler {
    func receivedData(_ data: Data, from peerID: MCPeerID)
    func receivedStream(_ stream: InputStream, from peerID: MCPeerID)
    func startedReceivingResource(_ resourceName: String, from peerID: MCPeerID)
    func finishedReceivingResource(_ resourceName: String, from peerID: MCPeerID, answer: ResourceAnswer)
    func peerJoined(_ id: MCPeerID)
    func peerJoining(_ id: MCPeerID)
    func peerLeft(_ id: MCPeerID)
    func sessionEnded()

    #if os(iOS)
    func peerDiscovered(_ id: MCPeerID) -> Bool
    func peerLost(_ id: MCPeerID)
    #elseif os(tvOS)
    func peerReceivedInvitation(_ id: MCPeerID) -> Bool
    #endif
}

public enum ResourceAnswer {
    case success(at: URL)
    case fail(err: Error)
}

public extension MultipeerHandler {
    func receivedData(_ data: Data, from peerID: MCPeerID) {
    }
    func receivedStream(_ stream: InputStream, from peerID: MCPeerID) {
    }
    func startedReceivingResource(_ resourceName: String, from peerID: MCPeerID) {
    }
    func finishedReceivingResource(_ resourceName: String, from peerID: MCPeerID, answer: ResourceAnswer) {
    }
    func peerJoined(_ id: MCPeerID) {
    }
    func peerJoining(_ id: MCPeerID) {
    }
    func peerLeft(_ id: MCPeerID) {
    }
    func sessionEnded() {
    }
}

