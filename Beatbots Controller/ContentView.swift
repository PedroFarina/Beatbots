//
//  ContentView.swift
//  Beatbots Controller
//
//  Created by Pedro Giuliano Farina on 09/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var manager = MultipeerManager()
    var body: some View {
        Text(manager.state.getText())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
