//
//  PlayerTextModifier.swift
//  Beatbots
//
//  Created by Pedro Giuliano Farina on 02/08/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import SwiftUI

public struct PlayerTextModifier: ViewModifier {
    let place: Int
    public func body(content: Content) -> some View {
        let color = place == 0 ? Color(#colorLiteral(red: 0.9921568627, green: 0.9921568627, blue: 0.9921568627, alpha: 1)) : Color(#colorLiteral(red: 0.4097467065, green: 0.4104432464, blue: 0.4432494044, alpha: 1))
        let font: Font = place == 0 ? .custom("Staatliches-Regular", size: 100) : .custom("Staatliches-Regular", size: 65)

        return content.foregroundColor(color).font(font)
    }
}
