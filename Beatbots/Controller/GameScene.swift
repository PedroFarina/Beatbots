//
//  GameScene.swift
//  Beatbots
//
//  Created by Pedro Giuliano Farina on 03/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import SpriteKit

public class GameScene: SKScene, StateObserver {

    var state: GameState = .StartMenu {
        willSet {
            if let behaviour = behaviour as? PausedBehaviour,
            newValue == .Playing {
                self.behaviour = behaviour.playingBehaviour
                behaviour.playingBehaviour.resume()
            } else {
                self.behaviour = newValue.behaviour(on: self)
            }
        }
    }
    var behaviour: GameBehaviour?
    public func stateChangedTo(_ state: GameState) {
        self.state = state
    }

    override init() {
        super.init()
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scaleMode = .aspectFill
    }

    public override init(size: CGSize) {
        super.init(size: size)
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scaleMode = .aspectFill
    }

    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
    }

    var backgroundNode: SKSpriteNode = SKSpriteNode(color: UIColor(red: 0.8, green: 0.8, blue: 1, alpha: 1), size: CGSize(width: 1, height: 0.6))
    public override func sceneDidLoad() {
        let texture = SKTexture(imageNamed: "startBackground")
        backgroundNode.texture = texture
        addChild(backgroundNode)
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

    public var stopUpdating: Bool = false

    var previousTime: TimeInterval = 0
    public override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        let deltaTime = currentTime - previousTime
        if !stopUpdating {
            behaviour?.update(deltaTime: deltaTime)
        }
        previousTime = currentTime
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
