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
        VStack(alignment: .trailing, spacing: 10) {
            VStack(spacing: 10) {
                HStack {
                    Text("AppleTV controler enabled")
                    Spacer()
                    Checkbox(initialValue: true)
                }.frame(width: 1000, height: 130, alignment: .center)
                HStack {
                    Text("Control Style")
                    Spacer()
                    SegmentedControl("Tap", "Click")
                }.frame(width: 1000, height: 130, alignment: .center)
            }.padding(.all, 30).background(RoundedRectangle(cornerRadius: 30).foregroundColor(Color(.sRGB, red: 0.3, green: 0.3, blue: 0.5, opacity: 0.5)))
            Button(action: {
                self.delegate.setState(to: .StartMenu)
            }) {
                Text("Back").foregroundColor(.white)
            }
        }
    }

    fileprivate func createImageOf(_ type: Character.Type) -> some View {
        let image = Image(type.imagePath).modifier(CharacterFrameModifier())
        if GlobalProperties.tvControllerEnabled {
            return AnyView(Button(action: {

            }) {
                image
            })
        } else {
            return AnyView(image)
        }
    }
    private func choosingCharactersView() -> some View {
        return VStack(alignment: .trailing) {
            HStack() {
                createImageOf(CID.self)
                createImageOf(CID.self)
                createImageOf(CID.self)
            }
            Button(action: {
                self.delegate.setState(to: .Playing)
            }) {
                Text("Confirm")
            }
        }
    }

    public var body: some View {
        switch delegate.getState() {
        case .StartMenu:
            return AnyView(startMenuView())
        case .Config:
            return AnyView(configMenuView())
        case .ChoosingCharacters:
            return AnyView(choosingCharactersView())
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
        return .ChoosingCharacters
    }
    func setState(to state: GameState) {
    }
}
#endif

struct CharacterFrameModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.padding(.all, 40).clipShape(Circle()).overlay(Circle().stroke(lineWidth: 3))
    }
}
