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
    private var frameNode: FrameNode
    private var confirmNode: SKSpriteNode
    private var gesturesNode: SKSpriteNode
    private static let phraseTexture = SKTexture(imageNamed: "choosingPhrase")
    private static let confirmTexture = SKTexture(imageNamed: "btnChoose")
    private static let selectTexture = SKTexture(imageNamed: "selectGestures")
    private var phraseNode = SKSpriteNode(texture: ChoosingBehaviour.phraseTexture)

    convenience init(scene:ControllerScene) {
        let confirmNode = SKSpriteNode(texture: ChoosingBehaviour.confirmTexture)
        confirmNode.size = CGSize(width: 0.25, height: 0.09)
        confirmNode.position = CGPoint(x: 0, y: -0.3)
        let frameNode = FrameNode()
        frameNode.position = CGPoint(x: 0, y: 0.25)
        self.init(scene: scene, frameNode: frameNode, confirmNode: confirmNode)
    }

    convenience init(scene: ControllerScene, frameNode: FrameNode) {
        let confirmNode = SKSpriteNode(texture: ChoosingBehaviour.confirmTexture)
        confirmNode.size = CGSize(width: 0.25, height: 0.09)
        confirmNode.position = CGPoint(x: 0, y: -0.3)
        self.init(scene: scene, frameNode: frameNode, confirmNode: confirmNode)
    }

    init(scene: ControllerScene, frameNode: FrameNode, confirmNode: SKSpriteNode) {
        self.scene = scene
        self.frameNode = frameNode
        self.confirmNode = confirmNode
        self.gesturesNode = SKSpriteNode(texture: ChoosingBehaviour.selectTexture)
        for i in 0 ..< scene.characters.count {
            if scene.characters[i] === frameNode.character {
                _selectedIndex = i
            }
            textures.append(SKTexture(imageNamed: type(of: scene.characters[i]).framePath))
        }
        gesturesNode.size = CGSize(width: 0.45, height: 0.15)
        gesturesNode.position.y = -0.1
        phraseNode.position.y = 0.06
        phraseNode.size = CGSize(width: 0.2, height: 0.025)
    }

    public func setup() {
        ThreadSafeController.resetScene(scene)
        confirmNode.texture = ChoosingBehaviour.confirmTexture
        ThreadSafeController.add(confirmNode, to: scene)
        ThreadSafeController.add(gesturesNode, to: scene)
        ThreadSafeController.add(frameNode, to: scene)
        ThreadSafeController.add(phraseNode, to: scene)
    }

    private var _selectedIndex: Int = 0 {
        didSet {
            frameNode.character = scene.characters[_selectedIndex]
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
