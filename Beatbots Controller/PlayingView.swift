//
//  PlayingView.swift
//  Beatbots Controller
//
//  Created by Pedro Giuliano Farina on 13/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import SwiftUI

struct PlayingView: View {
    var character: Binding<Character>
    var body: some View {
        VStack {
            Image(type(of: character.wrappedValue).imagePath).resizable().scaledToFit().frame(minWidth: 120, idealWidth: 150, maxWidth: 180, minHeight: 120, idealHeight: 150, maxHeight: 180, alignment: .center).padding().clipShape(Circle()).overlay(Circle().stroke(lineWidth: 3))
            VStack {
                Image(systemName: "arrow.up").resizable().scaledToFill().frame(minWidth: 50, idealWidth: 80, maxWidth: 100, minHeight: 50, idealHeight: 80, maxHeight: 100)
                HStack {
                    Image(systemName: "arrow.left").resizable().scaledToFill().frame(minWidth: 50, idealWidth: 80, maxWidth: 100, minHeight: 50, idealHeight: 80, maxHeight: 100)
                    Spacer()
                    Image(systemName: "arrow.right").resizable().scaledToFill().frame(minWidth: 50, idealWidth: 80, maxWidth: 100, minHeight: 50, idealHeight: 80, maxHeight: 100)
                }
                Image(systemName: "arrow.down").resizable().scaledToFill().frame(minWidth: 50, idealWidth: 80, maxWidth: 100, minHeight: 50, idealHeight: 80, maxHeight: 100)
            }.overlay(SwipeGesture(
                Swipe(direction: .up, action: {
                    MultipeerController.shared().sendToHost(Command.SwipeUp.rawValue, reliably: false)
                }),
                Swipe(direction: .left, action: {
                    MultipeerController.shared().sendToHost(Command.SwipeLeft.rawValue, reliably: false)
                }),
                Swipe(direction: .right, action: {
                    MultipeerController.shared().sendToHost(Command.SwipeRight.rawValue, reliably: false)
                }),
                Swipe(direction: .down, action: {
                    MultipeerController.shared().sendToHost(Command.SwipeDown.rawValue, reliably: false)
                })
            )).onTapGesture {
                MultipeerController.shared().sendToHost(Command.Tap.rawValue, reliably: false)
            }
            Button(action: {
                print("Power Up")
            }) {
                Text("Power Up")
            }.padding(.top, 100)
        }
    }
}
