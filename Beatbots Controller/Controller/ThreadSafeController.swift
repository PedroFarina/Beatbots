//
//  ThreadSafeScenne.swift
//  Beatbots Controller
//
//  Created by Pedro Giuliano Farina on 21/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import SpriteKit

public class ThreadSafeController {
    fileprivate init(){
    }
    private static let lockQueue = DispatchQueue(label: "ThreadSafe")
    public static func resetScene(_ scene: SKScene, exceptions: [String] = ["light"]) {
        lockQueue.sync {
            for child in scene.children where (child.name != "background" && !exceptions.contains(where: {child.name == $0})) {
                child.removeAllActions()
                child.removeFromParent()
            }
        }
    }
    public static func add(_ node:SKNode, to scene: SKScene) {
        lockQueue.sync {
            scene.addChild(node)
        }
    }
}
