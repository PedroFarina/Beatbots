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

    func makeText() -> (Text, Bool) {
        let state = manager.connectionState
        switch state {
        case .Connected(_):
            return (Text(""), true)
        default:
            return (Text(state.getText()), false)
        }
    }
    var body: some View {
        let showUI = makeText()
        return VStack {
            if showUI.1 {
                Circle().frame(width: 120, height: 120, alignment: .center)
                HStack {
                    Image(systemName: "arrow.left").resizable().scaledToFit()
                    Image(systemName: "arrow.right").resizable().scaledToFit()
                }.overlay(SwipeGesture(
                    Swipe(direction: .left, action: { print("Left")} ),
                    Swipe(direction: .right, action: { print("Right")} )
                ))
                Button(action: {
                    print("oie")
                }) {
                    Text("Confirm")
                }
            } else {
                showUI.0
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
