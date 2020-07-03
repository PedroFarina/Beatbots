//
//  Menu.swift
//  Beatbots
//
//  Created by Pedro Giuliano Farina on 03/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import SwiftUI

public struct Menu: View {
    init(delegate: StateHolder) {
        self.delegate = delegate
    }
    public private(set) var delegate: StateHolder

    private func startMenuView() -> some View {
        VStack {
            Button(action: {
                self.delegate.setState(to: .ChoosingCharacters)
            }) {
                Text("Start")
            }.padding(.top, 550)
            Button(action: {
                self.delegate.setState(to: .Config)
            }) {
                Text("Config")
            }
        }
    }
    
    public var body: some View {
        switch delegate.getState() {
        case .StartMenu:
            return AnyView(startMenuView())
        default:
            return AnyView(Text("Not implemented"))
        }
    }
}

#if DEBUG
struct Menu_Previews: PreviewProvider {
    static var previews: some View {
        Menu(delegate: TestStateHolder())
    }
}

struct TestStateHolder: StateHolder {
    func getState() -> GameState {
        return .StartMenu
    }
    func setState(to state: GameState) {
    }
}
#endif
