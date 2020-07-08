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
    fileprivate static let controlStyleKey = "tvControlStyle"
    fileprivate static let userDefaults = UserDefaults.standard
    #endif
    private init() {
    }
    public static let serviceType = "Beatbots"
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
    public static var tvControlStyle: TVControlStyle {
        get {
            if let value = userDefaults.string(forKey: controlStyleKey),
            let controlStyle = TVControlStyle(rawValue: value) {
                return controlStyle
            } else {
                defer {
                    tvControlStyle = .Tap
                }
                return .Tap
            }
        }

        set {
            userDefaults.set(newValue.rawValue, forKey: controlStyleKey)
        }
    }
    #endif
}

#if os(tvOS)
public enum TVControlStyle: String {
    case Tap
    case Click
}
#endif
