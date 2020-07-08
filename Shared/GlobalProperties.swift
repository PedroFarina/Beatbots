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
    #endif
    private init() {
    }
    public static let serviceType = "Beatbots"
    #if os(tvOS)
    public static let tvControllerPlayerID = "tvControllerPlayer"
    public static var tvControllerEnabled: Bool {
        get {
        return !UserDefaults.standard.bool(forKey: tvControllerKey)
        }
        set {
        UserDefaults.standard.set(!newValue, forKey: tvControllerKey)
        PlayersManager.shared().tvControllerEnabledChanged(to: newValue)
        }
    }
    #endif
}
