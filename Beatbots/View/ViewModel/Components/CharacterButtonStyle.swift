//
//  CharacterButtonStyle.swift
//  Beatbots
//
//  Created by Pedro Giuliano Farina on 23/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import SwiftUI

struct CharacterButtonStyle: ButtonStyle {
    static let unfocusedColor: Color = Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0))
    static let focusedColor: Color = Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.7))
    let focused: Bool
    func makeBody(configuration: Self.Configuration) -> some View {
        let color = focused ? CharacterButtonStyle.focusedColor : CharacterButtonStyle.unfocusedColor
        return configuration.label
        .modifier(TrapezeModifier(color: color))
    }
}

#if DEBUG
struct CharacterButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
        Button(action: {
        }) {
            Image("CID")
        }.buttonStyle(CharacterButtonStyle(focused: true))
    }
}
#endif
