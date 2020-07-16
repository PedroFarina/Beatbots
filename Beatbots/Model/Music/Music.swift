//
//  Music.swift
//  Beatbots
//
//  Created by Pedro Giuliano Farina on 15/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Foundation

public class Music {
    public let speed: TimeInterval = 2.5
    private let lockQueue = DispatchQueue(label: "Music")
    public init(name: String) {
        lanes[1] = [Note(command: .SwipeUp, at: 2.5), Note(command: .SwipeUp, at: 5), Note(command: .SwipeUp, at: 6), Note(command: .SwipeDown, at: 6.5), Note(command: .Tap, at: 7), Note(command: .SwipeLeft, at: 9), Note(command: .SwipeRight, at: 11)]
        lanes[2] = [Note(command: .SwipeUp, at: 3), Note(command: .SwipeUp, at: 4), Note(command: .SwipeUp, at: 7), Note(command: .SwipeDown, at: 8), Note(command: .Tap, at: 10), Note(command: .SwipeLeft, at: 11)]
        lanes[3] = [Note(command: .SwipeUp, at: 4), Note(command: .SwipeUp, at: 5), Note(command: .SwipeUp, at: 8), Note(command: .SwipeDown, at: 10), Note(command: .Tap, at: 10.3), Note(command: .SwipeLeft, at: 10.5), Note(command: .SwipeRight, at: 12)]
    }
    private var lanes: [Int: [Note]] = [:]
    public func getNextNoteFor(_ lane: Int) -> Note? {
        guard var notes = lanes[lane], !notes.isEmpty else {
            return nil
        }
        defer {
            lockQueue.sync {
                lanes[lane] = notes
            }
        }
        return notes.removeFirst()
    }
}

public struct Note {
    var command: Command
    var at: TimeInterval
}
