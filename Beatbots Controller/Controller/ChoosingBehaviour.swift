//
//  ChoosingState.swift
//  Beatbots Controller
//
//  Created by Pedro Giuliano Farina on 16/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import SpriteKit

public class ChoosingBehaviour: PlayerStateBehaviour {
    public private(set) var scene: ControllerScene
    public private(set) var nextBehaviour: PlayerStateBehaviour?

    private var textures: [SKTexture] = []
    private var frameNode: SKSpriteNode
    private var confirmNode: SKSpriteNode

    convenience init(scene:ControllerScene) {
        let confirmNode = SKSpriteNode(color: .green, size: CGSize(width: 0.1, height: 0.1))
        confirmNode.position = CGPoint(x: 0, y: -0.3)
        scene.addChild(confirmNode)
        let frameNode = SKSpriteNode(imageNamed: type(of: scene.characters.first ?? BiMO()).framePath)
        frameNode.position = CGPoint(x: 0, y: 0.2)
        frameNode.size = CGSize(width: 0.3, height: 0.3)
        scene.addChild(frameNode)
        self.init(scene: scene, frameNode: frameNode, confirmNode: confirmNode)
    }

    convenience init(scene: ControllerScene, frameNode: SKSpriteNode) {
        let confirmNode = SKSpriteNode(color: .green, size: CGSize(width: 0.1, height: 0.1))
        confirmNode.position = CGPoint(x: 0, y: -0.3)
        scene.addChild(confirmNode)
        self.init(scene: scene, frameNode: frameNode, confirmNode: confirmNode)
    }

    init(scene: ControllerScene, frameNode: SKSpriteNode, confirmNode: SKSpriteNode) {
        self.scene = scene
        for character in scene.characters {
            textures.append(SKTexture(imageNamed: type(of: character).framePath))
        }
        self.frameNode = frameNode
        self.confirmNode = confirmNode
    }

    public func setup() {
        confirmNode.color = .green
    }

    private var _selectedIndex: Int = 0 {
        didSet {
            frameNode.texture = textures[_selectedIndex]
        }
    }
    private var selectedIndex: Int {
        get {
            return _selectedIndex
        }
        set {
            if newValue >= scene.characters.count {
                _selectedIndex = 0
                return
            } else if newValue < 0 {
                _selectedIndex = scene.characters.count - 1
                return
            }
            _selectedIndex = newValue
        }
    }

    let threshold: CGFloat = 0.15
    var firstPoint: CGPoint?
    var recognizing = true
    public func touchDown(at pos: CGPoint) {
        recognizing = !confirmNode.contains(pos)
        firstPoint = pos
    }

    public func touchMoved(to pos: CGPoint) {
        checkSwipe(on: pos)
    }

    public func touchUp(at pos: CGPoint) {
        checkSwipe(on: pos)
        if !recognizing, let firstPoint = firstPoint,
            confirmNode.contains(pos) && confirmNode.contains(firstPoint) {
            nextBehaviour = ConfirmedBehaviour(scene: scene, frameNode: frameNode, confirmNode: confirmNode)
            MultipeerController.shared().sendToHost(GlobalProperties.selectKey + type(of:scene.characters[selectedIndex]).name, reliably: false)
        }
    }

    private func checkSwipe(on pos: CGPoint) {
        guard recognizing else {
            return
        }
        let movement = pos - (firstPoint ?? CGPoint(x: 0, y: 0))
        let value = abs(movement.x)
        if value > threshold {
            recognizing = false
            if pos.x < 0 {
                selectedIndex -= 1
            } else {
                selectedIndex += 1
            }
        }
    }
}
