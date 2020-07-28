//
//  PlayingState.swift
//  Beatbots Controller
//
//  Created by Pedro Giuliano Farina on 16/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import SpriteKit

public class PlayingBehaviour: PlayerStateBehaviour {
    public private(set) var scene: ControllerScene
    public private(set) var nextBehaviour: PlayerStateBehaviour?

    private var frameNode: FrameNode
    let gesturesNode: SKSpriteNode
    private static let phraseTexture = SKTexture(imageNamed: "playingPhrase")
    private static let gestureTexture = SKTexture(imageNamed: "playGestures")
    var phraseNode = SKSpriteNode(texture: PlayingBehaviour.phraseTexture)

    init(scene: ControllerScene, frameNode: FrameNode) {
        self.scene = scene
        self.frameNode = frameNode
        gesturesNode = SKSpriteNode(texture: PlayingBehaviour.gestureTexture)
        gesturesNode.size = CGSize(width: 0.45, height: 0.45)
        gesturesNode.position.y = -0.23
        phraseNode.position.y = 0.06
        phraseNode.size = CGSize(width: 0.25, height: 0.025)
    }

    public func setup() {
        ThreadSafeController.resetScene(scene)
        ThreadSafeController.add(frameNode, to: scene)
        ThreadSafeController.add(gesturesNode, to: scene)
        ThreadSafeController.add(phraseNode, to: scene)
    }

    let threshold: CGFloat = 0.1
    var firstPoint: CGPoint?
    var recognizing = true
    public func touchDown(at pos: CGPoint) {
        recognizing = true
        firstPoint = pos
    }

    public func touchMoved(to pos: CGPoint) {
        checkSwipe(on: pos)
    }

    public func touchUp(at pos: CGPoint) {
        checkSwipe(on: pos)
        guard recognizing else {
            return
        }
        MultipeerController.shared().sendToHost(Command.Tap.rawValue, reliably: false)
    }

    private func checkSwipe(on pos: CGPoint) {
        guard recognizing else {
            return
        }
        let movement = pos - (firstPoint ?? CGPoint(x: 0, y: 0))
        let value = max(abs(movement.x), abs(movement.y))
        if value > threshold {
            recognizing = false
            if abs(movement.x) == value {
                if movement.x < 0 {
                    MultipeerController.shared().sendToHost(Command.SwipeLeft.rawValue, reliably: false)
                } else {
                    MultipeerController.shared().sendToHost(Command.SwipeRight.rawValue, reliably: false)
                }
            } else if abs(movement.y) == value {
                if movement.y < 0 {
                    MultipeerController.shared().sendToHost(Command.SwipeDown.rawValue, reliably: false)
                } else {
                    MultipeerController.shared().sendToHost(Command.SwipeUp.rawValue, reliably: false)
                }
            }
        }
    }

    deinit {
        gesturesNode.removeFromParent()
    }
}

