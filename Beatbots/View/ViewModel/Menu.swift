//
//  Menu.swift
//  Beatbots
//
//  Created by Pedro Giuliano Farina on 03/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import SwiftUI

public struct Menu: View {
    public private(set) weak var delegate: StateController?
    public private(set) var currentState: GameState

    private func startMenuView() -> some View {
        VStack {
            Button(action: {
                self.delegate?.setState(to: .ChoosingCharacters)
            }) {
                Text("Play").foregroundColor(.white).padding([.leading, .trailing], 20)
            }.padding(.top, 800)
            Button(action: {
                self.delegate?.setState(to: .Settings)
            }) {
                Text("Settings").foregroundColor(.white).padding([.leading, .trailing], 10)
            }
        }
    }

    private func settingsMenuView() -> some View {
        VStack(alignment: .trailing, spacing: 10) {
            VStack(spacing: 10) {
                HStack {
                    Text("AppleTV controler enabled").foregroundColor(.white)
                    Spacer()
                    Checkbox(color: .white, initialValue: GlobalProperties.tvControllerEnabled) { value in
                        GlobalProperties.tvControllerEnabled = value
                    }
                }.frame(width: 1000, height: 130, alignment: .center)
                HStack {
                    Text("Perfect Notes").foregroundColor(.white)
                    Spacer()
                    Checkbox(color: .white, initialValue: GlobalProperties.perfectNotes) { value in
                        GlobalProperties.perfectNotes = value
                    }
                }.frame(width: 1000, height: 130, alignment: .center)
                HStack {
                    Text("Menu Music Enabled").foregroundColor(.white)
                    Spacer()
                    Checkbox(color: .white, initialValue: GlobalProperties.menuMusicEnabled) { value in
                        GlobalProperties.menuMusicEnabled = value
                    }
                }.frame(width: 1000, height: 130, alignment: .center)
                HStack {
                    Text("Curtains Closed").foregroundColor(.white)
                    Spacer()
                    Checkbox(color: .white, initialValue: GlobalProperties.curtainClosed) { value in
                        GlobalProperties.curtainClosed = value
                    }
                }.frame(width: 1000, height: 130, alignment: .center)
            }.padding(.all, 30).background(RoundedRectangle(cornerRadius: 30).foregroundColor(Color(.sRGB, red: 0.3, green: 0.3, blue: 0.5, opacity: 0.9)))
            Button(action: {
                self.delegate?.setState(to: .StartMenu)
            }) {
                Text("Back").foregroundColor(.white).padding([.leading, .trailing], 20)
            }
        }
    }


    @ObservedObject private var cid = PlayersManager.shared().cid
    @ObservedObject private var bimo = PlayersManager.shared().bimo
    @ObservedObject private var root = PlayersManager.shared().root
    @State private var selectedCharacter: Character? = nil

    fileprivate func makeButton(for character: Character) -> ChoosingButton {
        ChoosingButton(image: Image(type(of: character).imagePath), highLightColor: Color(PlayersManager.shared().colorFor(character.player))) {
            if character.isAvailable {
                PlayersManager.shared().selectCharacter(character: character, by: GlobalProperties.tvControllerPlayerID)
            } else if let player = PlayersManager.shared().getPlayerFrom(GlobalProperties.tvControllerPlayerID),
                character.player === player {
                PlayersManager.shared().deselectCharacter(character: character)
            }
        }
    }
    fileprivate func addButtonStyleTo(_ button: ChoosingButton, for character: Character) -> some View {
        let focused = selectedCharacter === character
        return button.buttonStyle(CharacterButtonStyle(focused: focused)).focusable(true) { value in
            if value {
                GlobalProperties.selectedButton = button
                self.selectedCharacter = character
            } else if focused {
                GlobalProperties.selectedButton = nil
                self.selectedCharacter = nil
            }
        }
    }
    fileprivate func makeButtonWithStyle(for character: Character) -> some View {
        let button = makeButton(for: character)
        return addButtonStyleTo(button, for: character)
    }
    private func choosingCharactersView() -> some View {
        let robots: [Character] = [bimo, root, cid]
        return VStack(alignment: .center) {
            Spacer()
            HStack(alignment: .bottom) {
                if GlobalProperties.tvControllerEnabled {
                    ForEach((0 ..< robots.count), id: \.self) {
                        self.makeButtonWithStyle(for: robots[$0])
                    }
                } else {
                    ForEach((0 ..< robots.count), id: \.self) {
                        Image(type(of: robots[$0]).imagePath).modifier(TrapezeModifier(color: Color( PlayersManager.shared().colorFor(robots[$0].player))))
                    }
                }
            }.frame(width: 1400, height: 700, alignment: .center)
            HStack(spacing: 1170) {
                Button(action: {
                    self.delegate?.setState(to: .StartMenu)
                }) {
                    Text("Back").foregroundColor(.white)
                }
                Button(action: {
                    let startGame: Bool
                    let tvPlayer = PlayersManager.shared().getPlayerFrom(GlobalProperties.tvControllerPlayerID)
                    if let tvPlayer = tvPlayer {
                        startGame = tvPlayer.selectedCharacter != nil
                    } else {
                        startGame = PlayersManager.shared().players.first(where: {$0.selectedCharacter != nil}) != nil
                    }
                    if startGame {
                        if PlayersManager.shared().players.count == 1 {
                            PlayersManager.shared().createBot()
                        }
                        if GlobalProperties.isFirstTime {
                            self.delegate?.setState(to: .Tutorial)
                        } else {
                            self.delegate?.setState(to: .Playing)
                        }
                    }
                }) {
                    Text("Confirm").foregroundColor(.white)
                }
            }
        }
    }
    private func gameOverView() -> some View {
        return VStack(alignment: .center) {
            HStack {
                Button(action: {
                    self.delegate?.setState(to: .Playing)
                }) {
                    Text("Play Again").foregroundColor(.white)
                }
                Button(action: {
                    self.delegate?.setState(to: .StartMenu)
                }) {
                    Text("Exit").foregroundColor(.white)
                }
            }.padding(.top, 750)
        }
    }

    private func pausedView() -> some View {
        let disconnected = PlayersManager.shared().getDisconnectedPlayers()
        let text: String
        if disconnected.isEmpty {
            text = ""
        } else {
            if disconnected.count == PlayersManager.shared().humanPlayers.count {
                text = "Lost connection, waiting reconnection."
            } else {
                text = "Lost connection to a player. Waiting reconnection."
            }
        }

        return ZStack() {
            Image("pauseFrame")
            VStack(alignment: .center) {
                Text(text).font(.largeTitle).foregroundColor(Color(#colorLiteral(red: 0.2980392157, green: 0.2980392157, blue: 0.3215686275, alpha: 1))).multilineTextAlignment(.center).padding(.top, 250)
                Spacer()
                if GlobalProperties.tvControllerEnabled ||
                   !(PlayersManager.shared().players.count == 1 &&
                    !PlayersManager.shared().players[0].connected) {
                    Button(action: {
                        self.delegate?.setState(to: .Playing)
                    }) {
                        Text("Return to game").foregroundColor(.white).font(.headline).padding(.all, 5)
                    }
                }
                Button(action: {
                    self.delegate?.setState(to: .StartMenu)
                }) {
                    Text("Main Menu").foregroundColor(.white).font(.headline).padding(.all, 5)
                }
            }.frame(width: 680, height: 750, alignment: .center)
        }
    }

    private func tutorialView() -> some View {
        VStack {
            Button(action: {
                GlobalProperties.isFirstTime = false
                self.delegate?.setState(to: .Playing)
            }) {
                Text("Got it!")
            }.padding(.top, 875)
        }
    }

    public var body: some View {
        switch currentState {
        case .StartMenu:
            return AnyView(startMenuView())
        case .Settings:
            return AnyView(settingsMenuView())
        case .ChoosingCharacters:
            return AnyView(choosingCharactersView())
        case .Tutorial:
            return AnyView(tutorialView())
        case .Paused:
            return AnyView(pausedView())
        case .GameOver:
            return AnyView(gameOverView())
        default:
            return AnyView(Text("Not implemented"))
        }
    }
}
