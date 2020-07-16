//
//  ConnectionStatus.swift
//  Beatbots Controller
//
//  Created by Pedro Giuliano Farina on 16/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

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

