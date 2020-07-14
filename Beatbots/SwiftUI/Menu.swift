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
                    Checkbox(initialValue: GlobalProperties.tvControllerEnabled) { value in
                        GlobalProperties.tvControllerEnabled = value
                    }
                }.frame(width: 1000, height: 130, alignment: .center)
                HStack {
                    Text("Control Style")
                    Spacer()
                    SegmentedControl(TVControlStyle.Click.rawValue, TVControlStyle.Tap.rawValue, selectedItem: GlobalProperties.tvControlStyle.rawValue) { value in
                        if let style = TVControlStyle(rawValue: value) {
                            GlobalProperties.tvControlStyle = style
                        }
                    }
                }.frame(width: 1000, height: 130, alignment: .center)
            }.padding(.all, 30).background(RoundedRectangle(cornerRadius: 30).foregroundColor(Color(.sRGB, red: 0.3, green: 0.3, blue: 0.5, opacity: 0.5)))
            Button(action: {
                self.delegate.setState(to: .StartMenu)
            }) {
                Text("Back").foregroundColor(.white)
            }
        }
    }


    @ObservedObject private var cid = PlayersManager.shared().cid
    @ObservedObject private var bimo = PlayersManager.shared().bimo
    @ObservedObject private var root = PlayersManager.shared().root
    fileprivate func createImageOf(_ character: Character) -> some View {
        let image = Image(type(of: character).imagePath)
            .resizable()
            .scaledToFit()
            .frame(minWidth: 280, idealWidth: 300, maxWidth: 320, minHeight: 280, idealHeight: 300, maxHeight: 320, alignment: .center)
            .padding()
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(lineWidth: 3))
            .overlay(
                Circle()
                    .fill(Color(PlayersManager.shared().colorFor(character.player)))
                    .frame(width: 80, height: 80)
                    .padding([.top, .leading], 230)
                    .overlay(Text("\(PlayersManager.shared().numberOfPlayer(character.player))")
                        .fontWeight(.bold)
                        .font(.largeTitle)
                        .accentColor(.white)
                        .frame(width: 80, height: 80, alignment: .center), alignment: .bottomTrailing))
        if GlobalProperties.tvControllerEnabled {
            return AnyView(Button(action: {
                if character.isAvailable {
                    PlayersManager.shared().selectCharacter(character: character, by: GlobalProperties.tvControllerPlayerID)
                } else if let player = PlayersManager.shared().getPlayer(from: GlobalProperties.tvControllerPlayerID),
                character.player === player {
                    PlayersManager.shared().deselectCharacter(character: character)
                }
            }) {
                image
            })
        } else {
            return AnyView(image)
        }
    }
    private func choosingCharactersView() -> some View {
        return VStack(alignment: .center) {
            HStack() {
                createImageOf(bimo)
                createImageOf(root)
                createImageOf(cid)
            }
            HStack(spacing: 1170) {
                Button(action: {
                    self.delegate.setState(to: .StartMenu)
                }) {
                    Text("Back")
                }
                Button(action: {
                    self.delegate.setState(to: .Playing)
                }) {
                    Text("Confirm")
                }
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
