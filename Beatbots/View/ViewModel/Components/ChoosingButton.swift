//
//  ChoosingButton.swift
//  Beatbots
//
//  Created by Pedro Giuliano Farina on 23/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import SwiftUI

public struct ChoosingButton: View {
    let image: Image
    let highLightColor: Color
    let action: () -> Void
    public var body: some View {
        Button(action: { }) {
            image.modifier(TrapezeModifier(color: highLightColor))
        }
    }
}
