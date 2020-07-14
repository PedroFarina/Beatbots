//
//  GameScene.swift
//  Beatbots
//
//  Created by Pedro Giuliano Farina on 03/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import SpriteKit

public class GameScene: SKScene, StateObserver {

    var state: GameState = .StartMenu
    public func stateChangedTo(_ state: GameState) {
        if state == .Playing {
            setupGame(with: "music")
        }
        self.state = state
    }

    init(stateDelegate: StateController) {
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
        guard let delegate = aDecoder.decodeObject(forKey: "stateDelegate") as? StateController else {
            return nil
        }
        self.init(stateDelegate: delegate)
    }

    var tvControllerPlayer: Player?
    var backgroundNode: SKSpriteNode = SKSpriteNode(color: UIColor(red: 0.8, green: 0.8, blue: 1, alpha: 1), size: CGSize(width: 1, height: 0.6))
    var characters: [SKSpriteNode] = []
    public override func sceneDidLoad() {
        addChild(backgroundNode)
        tvControllerPlayer = PlayersManager.shared().getPlayer(from: GlobalProperties.tvControllerPlayerID)
    }

    public func setupGame(with music: String) {
        backgroundNode.texture = SKTexture(imageNamed: "playBackground")
        var yValue = 0.4
        for character in PlayersManager.shared().players.map({return $0.selectedCharacter}) {
            yValue -= 0.20
            if let charValue = character {
                let characterNode = SKSpriteNode(imageNamed: type(of: charValue).framePath)
                characterNode.size = CGSize(width: 0.135, height: 0.135)
                characterNode.position = CGPoint(x: -0.4, y: yValue)
                characters.append(characterNode)
                addChild(characterNode)
            }
        }
    }

    let threshold: CGFloat = 0.2
    var firstPoint: CGPoint?
    var recognizing = true
    func touchDown(atPoint pos : CGPoint) {
        recognizing = true
        firstPoint = pos
    }

    func touchMoved(toPoint pos : CGPoint) {
        checkSwipe(on: pos)
    }

    func touchUp(atPoint pos : CGPoint) {
        checkSwipe(on: pos)
        guard recognizing else {
            return
        }
        tvControllerPlayer?.currentCommand = .Tap
    }

    private func checkSwipe(on pos: CGPoint) {
        guard recognizing else {
            return
        }
        let movement = pos - (firstPoint ?? CGPoint(x: 0, y: 0))
        let value = max(abs(movement.x), abs(movement.y))
        if value > threshold {
            recognizing = false
            if abs(pos.x) == value {
                if pos.x < 0 {
                    tvControllerPlayer?.currentCommand = .SwipeLeft
                } else {
                    tvControllerPlayer?.currentCommand = .SwipeRight
                }
            } else if abs(pos.y) == value {
                if pos.y < 0 {
                    tvControllerPlayer?.currentCommand = .SwipeDown
                } else {
                    tvControllerPlayer?.currentCommand = .SwipeUp
                }
            }
        }
    }

    var previousTime: TimeInterval = 0
    public override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        guard state == GameState.Playing else {
            return
        }
        let deltaTime = currentTime - previousTime
        for player in PlayersManager.shared().players {
            player.update(deltaTime: deltaTime)
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
