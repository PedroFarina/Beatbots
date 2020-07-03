//
//  ContentView.swift
//  Beatbots
//
//  Created by Pedro Giuliano Farina on 03/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            VStack {
                Button(action: {
                    print("Xisde")
                }) {
                    Text("Start")
                }.padding(.top, 550)
                Button(action: {
                    print("Xisde")
                }) {
                    Text("Config")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
