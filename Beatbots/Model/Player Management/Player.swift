//
//  Player.swift
//  Beatbots
//
//  Created by Pedro Giuliano Farina on 06/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import MultipeerConnectivity
import SpriteKit

public class Player {

    public let id: String
    public let isHuman: Bool
    public let chanceOfSuccess: Int?
    public var connected: Bool = true
    public let controlStyle: ControlStyle
    public weak var selectedCharacter: Character?
    public weak var frame: FrameNode? {
        didSet {
            updateFrame()
        }
    }
    public var currentCommand: Command?
    public var totalNotes: Int = 0
    public var correctNotes: Int = 0 {
        didSet {
            if correctNotes > oldValue {
                combo += 1
            }
        }
    }
    
    public var points: Double {
        get {
            if totalNotes == 0 || correctNotes == 0 { return 0 }
            return Double(correctNotes/totalNotes)
        }
    }
    private var _combo: Int = 0 {
        didSet {
            updateFrame()
        }
    }
    public var combo: Int {
        get {
            return _combo
        }
        set {
            if newValue < 14 && newValue > -14 {
                _combo = newValue
            }
        }
    }

    public let commandTimeOut: TimeInterval
    public private(set) var commandCountdown: TimeInterval

    init?() {
        guard GlobalProperties.tvControllerEnabled else {
            return nil
        }
        id = GlobalProperties.tvControllerPlayerID
        commandTimeOut = 0.25
        commandCountdown = commandTimeOut
        controlStyle = .tvController
        isHuman = true
        chanceOfSuccess = nil
    }
    init(id: MCPeerID) {
        self.id = id.displayName
        commandTimeOut = 0.3
        commandCountdown = commandTimeOut
        controlStyle = .iPhone
        isHuman = true
        chanceOfSuccess = nil
    }
    init(chanceOfSuccess: Int) {
        id = UUID().uuidString
        commandTimeOut = .infinity
        commandCountdown = commandTimeOut
        controlStyle = .tvController
        isHuman = false
        self.chanceOfSuccess = chanceOfSuccess
    }

    func updateFrame() {
        if let character = selectedCharacter {
            frame?.texture = SKTexture(imageNamed: "\(type(of: character).name)exp\(Int(combo/2))")
        }
    }

    func update(deltaTime: TimeInterval) {
        if currentCommand == nil { return }
        commandCountdown -= deltaTime
        guard commandCountdown <= 0 else {
            return
        }
        commandCountdown = commandTimeOut
        currentCommand = nil
    }

    public enum ControlStyle {
        case tvController
        case iPhone
    }
}
