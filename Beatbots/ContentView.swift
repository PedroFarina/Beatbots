//
//  ContentView.swift
//  Beatbots
//
//  Created by Pedro Giuliano Farina on 03/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import SwiftUI

struct ContentView: View, StateHolder {
    func getState() -> GameState {
        return gameState
    }

    func setState(to state: GameState) {
        gameState = state
    }

    @State var gameState: GameState = .StartMenu
    var body: some View {
        ZStack {
            SceneView().edgesIgnoringSafeArea(.all)
            if gameState != GameState.Playing  {
                Menu(delegate: self)
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

