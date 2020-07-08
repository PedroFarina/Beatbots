//
//  GameScene.swift
//  Beatbots
//
//  Created by Pedro Giuliano Farina on 03/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import SpriteKit

public class GameScene: SKScene {
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

    public override func sceneDidLoad() {
        self.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 1, alpha: 1)
    }

    func touchDown(atPoint pos : CGPoint) {
        print("Touch Down")
    }

    func touchMoved(toPoint pos : CGPoint) {
        print("Touch Move")
    }

    func touchUp(atPoint pos : CGPoint) {
        print("Touch Up")
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
