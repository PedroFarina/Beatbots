//
//  ConfirmedState.swift
//  Beatbots Controller
//
//  Created by Pedro Giuliano Farina on 16/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import SpriteKit

public class ConfirmedBehaviour: PlayerStateBehaviour {
    public var nextBehaviour: PlayerStateBehaviour?
    public var scene: ControllerScene

    var frameNode: FrameNode
    var confirmNode: SKSpriteNode
    let playingBehaviour: PlayingBehaviour
    init(scene: ControllerScene, frameNode: FrameNode, confirmNode: SKSpriteNode) {
        self.scene = scene
        self.frameNode = frameNode
        self.confirmNode = confirmNode
        self.playingBehaviour = PlayingBehaviour(scene: scene, frameNode: frameNode)
        nextBehaviour = playingBehaviour
    }

    public func setup() {
        ThreadSafeController.resetScene(scene)
        confirmNode.texture = SKTexture(imageNamed: "btnChange")
        ThreadSafeController.add(frameNode, to: scene)
        ThreadSafeController.add(confirmNode, to: scene)
    }

    var firstPoint: CGPoint?
    public func touchDown(at pos: CGPoint) {
        nextBehaviour = playingBehaviour
        firstPoint = pos
    }

    public func touchUp(at pos: CGPoint) {
        if let firstPoint = firstPoint, confirmNode.contains(firstPoint) && confirmNode.contains(pos) {
            nextBehaviour = ChoosingBehaviour(scene: scene, frameNode: frameNode, confirmNode: confirmNode)
            MultipeerController.shared().sendToHost(GlobalProperties.deselectKey, reliably: false)
        }
    }
}
