//
//  SceneView.swift
//  Beatbots
//
//  Created by Pedro Giuliano Farina on 16/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import SpriteKit
import SwiftUI

public struct SceneView: UIViewRepresentable {
    #if os(tvOS)
    public private(set) var scene: GameScene
    #elseif os(iOS)
    public private(set) var scene: ControllerScene
    #endif

    public  func makeUIView(context: Context) -> SKView {
        let view = SKView(frame: .zero)
        return view
    }

    public func updateUIView(_ uiView: SKView, context ext: Context) {
        if uiView.scene == nil {
            uiView.presentScene(scene)
        }
    }
}
