//
//  ContentView.swift
//  Beatbots
//
//  Created by Pedro Giuliano Farina on 03/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    @ObservedObject var stateHolder = StateHolder()
    var scene: SceneView?
    init() {
        MusicFilePlayer.playInBackground(fileName: "loop", ext: ".wav", looped: true)
        stateHolder.subscribe(PlayersManager.shared())
        PlayersManager.shared().stateHolder = stateHolder
        let gameScene = GameScene()
        stateHolder.subscribe(gameScene)
        scene = SceneView(scene: gameScene)
    }

    var body: some View {
        return ZStack {
            scene.edgesIgnoringSafeArea(.all)
            if stateHolder.state != GameState.Playing  {
                Menu(delegate: stateHolder, currentState: stateHolder.state)
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

