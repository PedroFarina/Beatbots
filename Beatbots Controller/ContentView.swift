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

    private static let characters: [Character] = [CID(), BiMO(), ROOT()]
    @State private var visibleCharacter: Character = ContentView.characters[0]
    var body: some View {
        let showUI = makeText()
        return VStack {
            if showUI.1 {
                Image(type(of: visibleCharacter).imagePath).resizable()
                    .scaledToFit()
                    .frame(minWidth: 120, idealWidth: 150, maxWidth: 180, minHeight: 120, idealHeight: 150, maxHeight: 180, alignment: .center)
                    .padding()
                    .clipShape(Circle()).overlay(
                        Circle()
                            .stroke(lineWidth: 3))
                HStack {
                    Spacer()
                    Image(systemName: "arrow.left").resizable().scaledToFill().frame(minWidth: 50, idealWidth: 80, maxWidth: 100, minHeight: 50, idealHeight: 80, maxHeight: 100)
                    Spacer()
                    Image(systemName: "arrow.right").resizable().scaledToFill().frame(minWidth: 50, idealWidth: 80, maxWidth: 100, minHeight: 50, idealHeight: 80, maxHeight: 100)
                    Spacer()
                }.overlay(SwipeGesture(
                    Swipe(direction: .left, action: {
                        if let index = ContentView.characters.firstIndex(where: {$0 === self.visibleCharacter}) {
                            let value: Int
                            if index - 1 < 0 {
                                value = ContentView.characters.count - 1
                            } else {
                                value = index - 1
                            }
                            self.visibleCharacter = ContentView.characters[value]
                        }
                    }),
                    Swipe(direction: .right, action: {
                        if let index = ContentView.characters.firstIndex(where: {$0 === self.visibleCharacter}) {
                            let value: Int
                            if index + 1 == ContentView.characters.count {
                                value = 0
                            } else {
                                value = index + 1
                            }
                            self.visibleCharacter = ContentView.characters[value]
                        }
                    } )
                )).padding([.top, .bottom], 120)
                Button(action: {
                    MultipeerController.shared().sendToHost(Data("Choose \(type(of: self.visibleCharacter).name)".utf8), reliably: false)
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
