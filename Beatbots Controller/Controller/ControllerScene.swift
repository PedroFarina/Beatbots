//
//  ControllerScene.swift
//  Beatbots Controller
//
//  Created by Pedro Giuliano Farina on 16/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import SpriteKit

public class ControllerScene: SKScene, StateObserver {

    override init() {
        super.init()
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scaleMode = .aspectFill
        _ = manager
    }

    public override init(size: CGSize) {
        super.init(size: size)
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scaleMode = .aspectFill
        _ = manager
    }

    required convenience init?(coder aDecoder: NSCoder) {
        if let size = aDecoder.decodeObject(forKey: "size") as? CGSize {
            self.init(size: size)
        } else {
            self.init()
        }
    }

    public override func sceneDidLoad() {
        backgroundColor = .gray
    }

    public let characters: [Character] = [BiMO(), ROOT(), CID()]
    lazy var manager: MultipeerManager = {
        let manager = MultipeerManager()
        manager.subscribe(self)
        self.connectionState = manager.connectionState
        self.playerState = manager.playerState
        return manager
    }()

    var connectionState: ConnectionStatus?
    var playerState: PlayerState? {
        didSet {
            if playerState != PlayerState.WaitingConnection,
                let nextBehaviour = behaviour?.nextBehaviour {
                behaviour = nextBehaviour
            } else {
                behaviour = playerState?.getBehaviour(for: self)
            }
        }
    }
    var behaviour: PlayerStateBehaviour?
    public func connectionStateChanged(to state: ConnectionStatus) {
        switch state {
        case .Disconnected(_):
            for character in characters {
                character.reset()
            }
        default:
            break
        }
        self.connectionState = state
    }
    public func playerStateChanged(to state: PlayerState) {
        playerState = state
    }

    func touchDown(atPoint pos : CGPoint) {
        behaviour?.touchDown(at: pos)
    }

    func touchMoved(toPoint pos : CGPoint) {
        behaviour?.touchMoved(to: pos)
    }

    func touchUp(atPoint pos : CGPoint) {
        behaviour?.touchUp(at: pos)
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }

    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }

    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
}
