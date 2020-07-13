//
//  MultipeerController.swift
//  Beatbots
//
//  Created by Pedro Giuliano Farina on 06/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import MultipeerConnectivity

public enum ConnectionType {
    case host
    case peer
}

public class MultipeerController: NSObject {

    public static func shared() -> MultipeerController {
        return sharedInstance
    }
    private static let sharedInstance: MultipeerController = {
        let mc = MultipeerController ()
        return mc
    }()

    private override init() {
        self.serviceType = GlobalProperties.serviceType
        #if os(iOS)
        browser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: serviceType)
        connectionType = .peer
        #elseif os(tvOS)
        advertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: nil, serviceType: serviceType)
        connectionType = .host
        #endif
        super.init()
        session.delegate = self
        #if os(iOS)
        browser.delegate = self
        #elseif os(tvOS)
        advertiser.delegate = self
        #endif
    }

    public let serviceType: String
    public let connectionType: ConnectionType

    private let myPeerID = MCPeerID(displayName: UIDevice.current.name)
    private lazy var session: MCSession = MCSession(peer: myPeerID)

    #if os(iOS)
    private var browser: MCNearbyServiceBrowser
    private var host: MCPeerID?
    #elseif os(tvOS)
    private var advertiser: MCNearbyServiceAdvertiser
    #endif

    public var delegate: MultipeerHandler?

    public func startService() {
        #if os(iOS)
        browser.startBrowsingForPeers()
        #elseif os(tvOS)
        advertiser.startAdvertisingPeer()
        #endif
    }

    public func stopService() {
        #if os(iOS)
        browser.stopBrowsingForPeers()
        #elseif os(tvOS)
        advertiser.stopAdvertisingPeer()
        #endif
    }

    public func endSession() {
        if connectionType == .peer {
            session.disconnect()
        } else if connectionType == .host {
            sendToAllPeers(Data("disconnect".utf8), reliably: false)
            session.disconnect()
        }
        delegate?.sessionEnded()
    }

    public func sendToAllPeers(_ data: Data, reliably: Bool) {
        sendToPeers(data, reliably: reliably, peers: connectedPeers)
    }

    #if os(iOS)
    public func sendToHost(_ data: Data, reliably: Bool) {
        if let host = host {
            sendToPeers(data, reliably: reliably, peers: [host])
        }
    }
    #endif

    public func sendToPeers(_ data: Data, reliably: Bool, peers: [MCPeerID]) {
        guard !peers.isEmpty else { return }
        do {
            try session.send(data, toPeers: peers, with: reliably ? .reliable : .unreliable)
        } catch {
            print("error sending data to peers \(peers): \(error.localizedDescription)")
        }
    }

    public var connectedPeers: [MCPeerID] {
        return session.connectedPeers
    }
}

extension MultipeerController: MCSessionDelegate {
    public func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        if state == .connected {
            delegate?.peerJoined(peerID)
        } else if state == .connecting {
            delegate?.peerJoining(peerID)
        }
        else if state == .notConnected {
            delegate?.peerLeft(peerID)
            #if os(iOS)
            if peerID == host {
                host = nil
            }
            #endif
        }
    }

    public func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let message = String(bytes: data, encoding: .utf8),
            message == "disconnect",
            connectionType == .peer {
            endSession()
        } else {
            delegate?.receivedData(data, from: peerID)
        }
    }

    public func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        delegate?.receivedStream(stream, from: peerID)
    }

    public func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        delegate?.startedReceivingResource(resourceName, from: peerID)
    }

    public func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        if let url = localURL {
            delegate?.finishedReceivingResource(resourceName, from: peerID, answer: ResourceAnswer.success(at: url))
        } else if let error = error {
            delegate?.finishedReceivingResource(resourceName, from: peerID, answer: ResourceAnswer.fail(err: error))
        }
    }


}

#if os(iOS)
extension MultipeerController: MCNearbyServiceBrowserDelegate {
    public func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        if delegate?.peerDiscovered(peerID) ?? false {
            browser.invitePeer(peerID, to: session, withContext: nil, timeout: 15)
            #if os(iOS)
            self.host = peerID
            #endif
        }
    }

    public func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        delegate?.peerLost(peerID)
    }
}
#elseif os(tvOS)
extension MultipeerController: MCNearbyServiceAdvertiserDelegate {
    public func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        if delegate?.peerReceivedInvitation(peerID) ?? false {
            invitationHandler(true, self.session)
        } else {
            invitationHandler(false, nil)
        }
    }
}
#endif

