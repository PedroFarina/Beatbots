//
//  ContentView.swift
//  Beatbots
//
//  Created by Pedro Giuliano Farina on 03/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import SwiftUI

struct ContentView: View, StateHolder {

    init() {
        PlayersManager.shared().stateHolder = self
    }

    func getState() -> GameState {
        return gameState
    }

    func setState(to state: GameState) {
        if gameState == .StartMenu && state == .ChoosingCharacters {
            MultipeerController.shared().startService()
        } else if (gameState == .ChoosingCharacters || gameState == .GameOver) && state == .StartMenu {
            MultipeerController.shared().stopService()
            MultipeerController.shared().endSession()
        } else if state == .Playing {
            MultipeerController.shared().sendToAllPeers(GlobalProperties.startKey, reliably: false)
        }

        gameState = state
    }

    @State var gameState: GameState = .StartMenu
    var body: some View {
        ZStack {
            SceneView(scene: GameScene(stateDelegate: self)).edgesIgnoringSafeArea(.all)
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

