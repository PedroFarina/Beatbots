//
//  AppDelegate.swift
//  Beatbots
//
//  Created by Pedro Giuliano Farina on 03/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import UIKit
import SwiftUI

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    weak var stateHolder: StateController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // Create the SwiftUI view that provides the window contents.
        MusicFilePlayer.setup()
        let contentView = ContentView()
        stateHolder = contentView.stateHolder

        // Use a UIHostingController as window root view controller.
        let window = UIWindow(frame: UIScreen.main.bounds)
        let myHosting = MyHosting(rootView: contentView)
        myHosting.stateHolder = stateHolder
        window.rootViewController = myHosting
        self.window = window
        window.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        if stateHolder?.getState() == GameState.Playing {
            stateHolder?.setState(to: .Paused)
        }
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        if stateHolder?.getState() == GameState.Playing {
            stateHolder?.setState(to: .Paused)
        } else {
            MultipeerController.shared().endSession()
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        MultipeerController.shared().endSession()
    }

}

class MyHosting: UIHostingController<ContentView> {
    weak var stateHolder: StateController?
    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        if presses.first?.type == UIPress.PressType.menu {
            switch stateHolder?.getState() {
            case .StartMenu:
                exit(EXIT_SUCCESS)
            case .Settings:
                stateHolder?.setState(to: .StartMenu)
            case .ChoosingCharacters:
                stateHolder?.setState(to: .StartMenu)
            case .Paused:
                stateHolder?.setState(to: .Playing)
            case .GameOver:
                stateHolder?.setState(to: .StartMenu)
            case .Playing:
                stateHolder?.setState(to: .Paused)
            default:
                break
            }
        } else {
            super.pressesBegan(presses, with: event)
        }
    }

    override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        if let btn = GlobalProperties.selectedButton,
            let type = presses.first?.type,
        (type == UIPress.PressType.select || type.rawValue == 2040) {
            btn.action()
            super.pressesEnded(presses, with: event)
        } else if presses.first?.type != UIPress.PressType.menu {
            super.pressesEnded(presses, with: event)
        }
    }
}
