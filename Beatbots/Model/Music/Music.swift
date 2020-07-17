//
//  Music.swift
//  Beatbots
//
//  Created by Pedro Giuliano Farina on 15/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Foundation

public class Music {
    public let speed: TimeInterval = 3
    private let lockQueue = DispatchQueue(label: "Music")
    public init(name: String) {
        lanes[.Harmony] = [Note(command: .SwipeUp, at: 2.5), Note(command: .SwipeUp, at: 5), Note(command: .SwipeUp, at: 6), Note(command: .SwipeDown, at: 6.5), Note(command: .Tap, at: 7), Note(command: .SwipeLeft, at: 9), Note(command: .SwipeRight, at: 11), Note(command: .SwipeUp, at: 13.5), Note(command: .SwipeUp, at: 15), Note(command: .SwipeUp, at: 16), Note(command: .SwipeDown, at: 17), Note(command: .Tap, at: 19), Note(command: .SwipeLeft, at: 19.5), Note(command: .SwipeRight, at: 21)]
        lanes[.Melody] = [Note(command: .SwipeDown, at: 3), Note(command: .SwipeUp, at: 4), Note(command: .SwipeUp, at: 7), Note(command: .SwipeDown, at: 8), Note(command: .Tap, at: 10), Note(command: .SwipeLeft, at: 11), Note(command: .SwipeUp, at: 14), Note(command: .SwipeUp, at: 16), Note(command: .SwipeUp, at: 16.5), Note(command: .SwipeDown, at: 17), Note(command: .Tap, at: 19), Note(command: .SwipeLeft, at: 22)]
        lanes[.Rhythm] = [Note(command: .Tap, at: 4), Note(command: .SwipeUp, at: 5), Note(command: .SwipeUp, at: 8), Note(command: .SwipeDown, at: 10), Note(command: .Tap, at: 10.5), Note(command: .SwipeLeft, at: 10.5), Note(command: .SwipeRight, at: 12), Note(command: .SwipeUp, at: 14), Note(command: .SwipeUp, at: 15), Note(command: .SwipeUp, at: 18), Note(command: .SwipeDown, at: 19), Note(command: .Tap, at: 21), Note(command: .SwipeLeft, at: 23), Note(command: .SwipeRight, at: 25)]
    }
    private var lanes: [MusicPart: [Note]] = [:]
    public func getNextNoteFor(_ lane: MusicPart) -> Note? {
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
