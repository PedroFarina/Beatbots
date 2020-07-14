//
//  ContentView.swift
//  Beatbots Controller
//
//  Created by Pedro Giuliano Farina on 09/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView: View {
    @ObservedObject private var manager = MultipeerManager()

    func makeText() -> (String, Bool) {
        let state = manager.connectionState
        let str = state.getText()

        switch state {
        case .Connected(_):
            return (str, true)
        default:
            return (str, false)
        }
    }

    public static let characters: [Character] = [CID(), BiMO(), ROOT()]
    @State private var visibleCharacter: Character = ContentView.characters[0]
    var body: some View {
        let showUI = makeText()
        if manager.characterState ==  .Playing {
            return AnyView(Text(""))
        } else {
            return AnyView(SelectionView(connected: showUI.1, connectionText: showUI.0, selecting: manager.characterState == .Choosing, visibleCharacter: $visibleCharacter))
        }
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
