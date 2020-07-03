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

    private func configMenuView() -> some View {
        VStack(alignment: .center, spacing: 10) {
            HStack {
                Text("AppleTV controler enabled")
                Spacer()
                SegmentedControl("Yes", "No")
            }.frame(width: 1000, height: 130, alignment: .center)
            HStack {
                Text("Control Style")
                Spacer()
                SegmentedControl("Tap", "Click")
            }.frame(width: 1000, height: 130, alignment: .center)
        }.padding(.all, 30).background(RoundedRectangle(cornerRadius: 30).foregroundColor(Color(.sRGB, red: 0.3, green: 0.3, blue: 0.5, opacity: 0.5)))

    }

    public var body: some View {
        switch delegate.getState() {
        case .StartMenu:
            return AnyView(startMenuView())
        case .Config:
            return AnyView(configMenuView())
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
        return .Config
    }
    func setState(to state: GameState) {
    }
}
#endif
