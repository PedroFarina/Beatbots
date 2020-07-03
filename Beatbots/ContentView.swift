//
//  ContentView.swift
//  Beatbots
//
//  Created by Pedro Giuliano Farina on 03/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @State var gameStarted: Bool = false
    var body: some View {
        ZStack {
            SceneView().edgesIgnoringSafeArea(.all)
            if !gameStarted {
                VStack {
                    Button(action: {
                        self.gameStarted = true
                    }) {
                        Text("Start")
                    }.padding(.top, 550)
                    Button(action: {
                        print("Config")
                    }) {
                        Text("Config")
                    }
                }
            }
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

