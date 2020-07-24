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
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        if stateHolder?.getState() == GameState.Playing {
            stateHolder?.setState(to: .Paused)
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
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
