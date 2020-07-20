//
//  GlobalProperties.swift
//  Beatbots
//
//  Created by Pedro Giuliano Farina on 06/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Foundation

public class GlobalProperties {
    #if os(tvOS)
    fileprivate static let tvControllerKey = "tvControllerDisabled"
    fileprivate static let curtainClosedKey = "curtainClosed"
    fileprivate static let perfectNotesKey = "perfectNotes"
    fileprivate static let userDefaults = UserDefaults.standard
    #endif
    private init() {
    }
    public static let serviceType = "Beatbots"
    public static let selectKey = "Select"
    public static let deselectKey = "Deselect"
    public static let confirmationKey = "ActionOccur"
    public static let startKey = "Start"
    #if os(tvOS)
    public static let tvControllerPlayerID = "tvControllerPlayer"
    public static var tvControllerEnabled: Bool {
        get {
            return !userDefaults.bool(forKey: tvControllerKey)
        }
        set {
            userDefaults.set(!newValue, forKey: tvControllerKey)
            PlayersManager.shared().tvControllerEnabledChanged(to: newValue)
        }
    }
    public static var curtainClosed: Bool {
        get {
        return userDefaults.bool(forKey: curtainClosedKey)
        }
        set {
        userDefaults.set(newValue, forKey: curtainClosedKey)
        }
    }
    public static var perfectNotes: Bool {
        get {
        return userDefaults.bool(forKey: perfectNotesKey)
        }
        set {
        userDefaults.set(newValue, forKey: perfectNotesKey)
        }
    }
    #endif
}
