//
//  SelectionView.swift
//  Beatbots Controller
//
//  Created by Pedro Giuliano Farina on 13/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import SwiftUI

struct SelectionView: View {
    var connected: Bool
    var connectionText: String
    var selecting: Bool
    var visibleCharacter: Binding<Character>

    var body: some View {
        VStack {
            if connected {
                Image(type(of: visibleCharacter.wrappedValue).imagePath).resizable()
                    .scaledToFit()
                    .frame(minWidth: 120, idealWidth: 150, maxWidth: 180, minHeight: 120, idealHeight: 150, maxHeight: 180, alignment: .center)
                    .padding()
                    .clipShape(Circle()).overlay(
                        Circle()
                    .stroke(lineWidth: 3))
                if selecting {
                    HStack {
                        Spacer()
                        Image(systemName: "arrow.left").resizable().scaledToFill().frame(minWidth: 50, idealWidth: 80, maxWidth: 100, minHeight: 50, idealHeight: 80, maxHeight: 100)
                        Spacer()
                        Image(systemName: "arrow.right").resizable().scaledToFill().frame(minWidth: 50, idealWidth: 80, maxWidth: 100, minHeight: 50, idealHeight: 80, maxHeight: 100)
                        Spacer()
                    }.overlay(SwipeGesture(
                        Swipe(direction: .left, action: {
                            if let index = ContentView.characters.firstIndex(where: {$0 === self.visibleCharacter.wrappedValue }) {
                                let value: Int
                                if index - 1 < 0 {
                                    value = ContentView.characters.count - 1
                                } else {
                                    value = index - 1
                                }
                                self.visibleCharacter.wrappedValue = ContentView.characters[value]
                            }
                        }),
                        Swipe(direction: .right, action: {
                            if let index = ContentView.characters.firstIndex(where: {$0 === self.visibleCharacter.wrappedValue }) {
                                let value: Int
                                if index + 1 == ContentView.characters.count {
                                    value = 0
                                } else {
                                    value = index + 1
                                }
                                self.visibleCharacter.wrappedValue = ContentView.characters[value]
                            }
                        } )
                    )).padding(.top, 120)
                }
                Button(action: {
                    MultipeerController.shared().sendToHost("\(self.selecting ? GlobalProperties.selectKey : GlobalProperties.deselectKey)\(type(of: self.visibleCharacter.wrappedValue).name)", reliably: false)
                }) {
                    Text(selecting ? "Select" : "Deselect")
                }.padding(.top, 120)
            } else {
                Text(connectionText)
            }
        }
    }
}
