//
//  MultipeerManager.swift
//  Beatbots Controller
//
//  Created by Pedro Giuliano Farina on 09/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import MultipeerConnectivity
import SwiftUI

public protocol StateObserver: class {
    func connectionStateChanged(to state: ConnectionStatus)
    func playerStateChanged(to state: PlayerState)
}

public class MultipeerManager: MultipeerHandler {
    private var observers: [StateObserver] = []
    public weak var scene:ControllerScene?
    public func subscribe(_ observer: StateObserver) {
        observers.append(observer)
    }
    public func unsubscribe(_ observer: StateObserver) {
        if let index = observers.firstIndex(where: {$0 === observer}) {
            observers.remove(at: index)
        }
    }

    public private(set) var connectionState: ConnectionStatus = .Searching {
        didSet {
            for observer in observers {
                observer.connectionStateChanged(to: connectionState)
            }
        }
    }
    public private(set) var playerState: PlayerState = .WaitingConnection {
        didSet {
            for observer in observers {
                observer.playerStateChanged(to: playerState)
            }
        }
    }
    let myQueue = DispatchQueue(label: "MultipeerManager")

    init() {
        MultipeerController.shared().delegate = self
        MultipeerController.shared().startService()
    }

    public func peerDiscovered(_ id: MCPeerID) -> Bool {
        self.connectionState = .Found(id: id.displayName)
        return true
    }

    public func peerLeft(_ id: MCPeerID) {
        guard id == MultipeerController.shared().host else { return }
        self.connectionState = .Disconnected(id: id.displayName)
        self.playerState = .WaitingConnection
        MultipeerController.shared().stopService()
        myQueue.asyncAfter(deadline: .now() + 3) {
            self.connectionState = .Searching
            MultipeerController.shared().startService()
        }
    }

    public func peerJoining(_ id: MCPeerID) {
        guard id == MultipeerController.shared().host else { return }
        self.connectionState = .Connecting(id: id.displayName)
    }

    public func peerJoined(_ id: MCPeerID) {
        guard id == MultipeerController.shared().host else { return }
        self.connectionState = .Connected(id: id.displayName)
        self.playerState = .Choosing
    }

    public func peerLost(_ id: MCPeerID) {
        guard id == MultipeerController.shared().host else { return }
        self.connectionState = .Lost(id: id.displayName)
    }

    public func receivedData(_ data: Data, from peerID: MCPeerID) {
        if let str = String(bytes: data, encoding: .utf8) {
            DispatchQueue.main.async {
                if str.starts(with: GlobalProperties.startKey) {
                    if self.playerState == .Confirmed {
                        self.playerState = .Playing
                    } else if str.count > GlobalProperties.startKey.count {
                        if let scene = self.scene,
                            let character = scene.characters.first(where:
                            {type(of:$0).name == str.suffix(str.count - GlobalProperties.startKey.count)})
                        {
                            self.playerState = .Playing
                            let frameNode = FrameNode(character: character)
                            frameNode.position = CGPoint(x: 0, y: 0.2)
                            scene.addChild(frameNode)
                            scene.behaviour = PlayingBehaviour(scene: scene, frameNode: frameNode)
                        }
                    }
                    else {
                        MultipeerController.shared().endSession()
                    }
                } else if str == GlobalProperties.confirmationKey {
                    self.playerState.toggle()
                }
            }
        }
    }
}
