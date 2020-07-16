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
    var body: some View {
        SceneView(scene: ControllerScene())
    }
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
