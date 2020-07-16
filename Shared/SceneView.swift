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
    public private(set) var scene: SKScene

    public  func makeUIView(context: Context) -> SKView {
        return SKView(frame: .zero)
    }

    public func updateUIView(_ uiView: SKView, context ext: Context) {
        uiView.presentScene(scene)
    }
}
