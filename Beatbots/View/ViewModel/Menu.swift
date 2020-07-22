//
//  Menu.swift
//  Beatbots
//
//  Created by Pedro Giuliano Farina on 03/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import SwiftUI

public struct Menu: View {
    public private(set) var delegate: StateController
    public private(set) var currentState: GameState

    private func startMenuView() -> some View {
        VStack {
            Button(action: {
                self.delegate.setState(to: .ChoosingCharacters)
            }) {
                Text("Play").foregroundColor(.white).padding([.leading, .trailing], 20)
            }.padding(.top, 800)
            Button(action: {
                self.delegate.setState(to: .Config)
            }) {
                Text("Settings").foregroundColor(.white).padding([.leading, .trailing], 10)
            }
        }
    }

    private func configMenuView() -> some View {
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
            }.padding(.all, 30).background(RoundedRectangle(cornerRadius: 30).foregroundColor(Color(.sRGB, red: 0.3, green: 0.3, blue: 0.5, opacity: 0.5)))
            Button(action: {
                self.delegate.setState(to: .StartMenu)
            }) {
                Text("Back").foregroundColor(.white).padding([.leading, .trailing], 20)
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
                } else if let player = PlayersManager.shared().getPlayerFrom(GlobalProperties.tvControllerPlayerID),
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
                    if let player = PlayersManager.shared()
                        .getPlayerFrom(GlobalProperties.tvControllerPlayerID)
                    {
                        if player.selectedCharacter != nil {
                            self.delegate.setState(to: .Playing)
                        }
                    } else if let _ = PlayersManager.shared()
                        .players.first(where: {$0.selectedCharacter != nil}) {
                        self.delegate.setState(to: .Playing)
                    }
                }) {
                    Text("Confirm")
                }
            }
        }
    }
    private func gameOverView() -> some View {
        return VStack(alignment: .center) {
            HStack {
                Button(action: {
                    self.delegate.setState(to: .Playing)
                }) {
                    Text("Play Again")
                }
                Button(action: {
                    self.delegate.setState(to: .StartMenu)
                }) {
                    Text("Exit")
                }
            }.padding(.top, 750)
        }
    }

    private func pausedView() -> some View {
        let disconnected = PlayersManager.shared().getDisconnectedPlayers()
        let text = disconnected.isEmpty ? "" : "A player has left.Wait for him to reconnect?"
        return ZStack() {
            Image("pauseFrame")
            VStack(alignment: .center) {
                Text(text).font(.largeTitle).foregroundColor(Color(#colorLiteral(red: 0.2980392157, green: 0.2980392157, blue: 0.3215686275, alpha: 1))).multilineTextAlignment(.center).padding(.top, 250)
                Spacer()
                if !(!GlobalProperties.tvControllerEnabled && PlayersManager.shared().players.count == 1) {
                    Button(action: {
                        self.delegate.setState(to: .Playing)
                    }) {
                        Text("Return to game").foregroundColor(.white).font(.headline).padding(.all, 5)
                    }
                }
                Button(action: {
                    self.delegate.setState(to: .StartMenu)
                }) {
                    Text("Main Menu").foregroundColor(.white).font(.headline).padding(.all, 5)
                }
            }.frame(width: 680, height: 750, alignment: .center)
        }
    }

    public var body: some View {
        switch currentState {
        case .StartMenu:
            return AnyView(startMenuView())
        case .Config:
            return AnyView(configMenuView())
        case .ChoosingCharacters:
            return AnyView(choosingCharactersView())
        case .Paused:
            return AnyView(pausedView())
        case .GameOver:
            return AnyView(gameOverView())
        default:
            return AnyView(Text("Not implemented"))
        }
    }
}
