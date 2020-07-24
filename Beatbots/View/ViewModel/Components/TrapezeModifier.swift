//
//  TrapezeModifier.swift
//  Beatbots
//
//  Created by Pedro Giuliano Farina on 23/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import SwiftUI

public struct TrapezeModifier: ViewModifier {
    let color: Color
    public func body(content: Content) -> some View {
        content.overlay(
            GeometryReader { geometry in
                Path { path in
                    let w = geometry.size.width
                    let h = geometry.size.height

                    path.move(to: CGPoint(x: w/3 - 3, y: 0))
                    path.addLine(to: CGPoint(x: (w/3 * 2) + 3, y: 0))
                    path.addLine(to: CGPoint(x: w, y: h))
                    path.addLine(to: CGPoint(x: 0, y: h))
                    path.addLine(to: CGPoint(x: w/3 - 3, y: 0))
                }.fill(LinearGradient(gradient: Gradient(colors: [self.color, self.color.opacity(0)]), startPoint: .top, endPoint: .bottom))
        }
        )
    }
}
