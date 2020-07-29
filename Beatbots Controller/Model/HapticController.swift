//
//  HapticEngine.swift
//  Beatbots Controller
//
//  Created by Pedro Giuliano Farina on 29/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import CoreHaptics

public class HapticController {

    let engine: CHHapticEngine
    init?() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return nil }
        do {
            engine = try CHHapticEngine()
            try engine.start()
        } catch {
            return nil
        }
    }

    private let successPattern: CHHapticPattern? = {
        let successIntensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.7)
        let successSharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.7)
        let successEvent = CHHapticEvent(eventType: .hapticTransient, parameters: [successIntensity, successSharpness], relativeTime: 0)

        return try? CHHapticPattern(events: [successEvent], parameterCurves: [])
    }()
    public func success() {
        if let pattern = successPattern {
            let player = try? engine.makePlayer(with: pattern)
            try? player?.start(atTime: 0)
        }
    }

    private let failurePattern: CHHapticPattern? = {
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)

        let firstEvent = CHHapticEvent(eventType: .hapticContinuous, parameters: [intensity,sharpness], relativeTime: 0, duration: 0.2)

        return try? CHHapticPattern(events: [firstEvent], parameterCurves: [])
    }()
    public func failure() {
        if let pattern = failurePattern {
            let player = try? engine.makePlayer(with: pattern)
            try? player?.start(atTime: 0)
        }
    }
}
