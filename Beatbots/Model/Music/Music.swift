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
        lanes[.Melody] = [
            Note(command: .Tap, at: 6.6+speed),
            Note(command: .Tap, at: 7.0+speed),
            Note(command: .Tap, at: 7.3+speed),
            Note(command: .Tap, at: 7.6+speed),
            Note(command: .Tap, at: 8+speed),
            Note(command: .Tap, at: 8.3+speed),
            Note(command: .Tap, at: 8.6+speed),

            Note(command: .Tap, at: 10+speed),
            Note(command: .Tap, at: 10.3+speed),
            Note(command: .Tap, at: 10.6+speed),
            Note(command: .Tap, at: 11+speed),
            Note(command: .Tap, at: 11.3+speed),
            Note(command: .Tap, at: 11.6+speed),

            Note(command: .Tap, at: 13+speed),
            Note(command: .Tap, at: 13.3+speed),
            Note(command: .Tap, at: 13.6+speed),
            Note(command: .Tap, at: 14+speed),
            Note(command: .Tap, at: 14.3+speed),
            Note(command: .Tap, at: 14.6+speed),
            Note(command: .Tap, at: 15+speed),

            Note(command: .Tap, at: 16+speed),
            Note(command: .Tap, at: 16.3+speed),
            Note(command: .Tap, at: 16.6+speed),
            Note(command: .Tap, at: 17+speed),
            Note(command: .Tap, at: 17.3+speed),
            Note(command: .Tap, at: 17.6+speed),
///
            Note(command: .Tap, at: 19+speed),
            Note(command: .Tap, at: 19.0+speed),
            Note(command: .Tap, at: 19.3+speed),
            Note(command: .Tap, at: 19.6+speed),
            Note(command: .Tap, at: 20+speed),
            Note(command: .Tap, at: 20.3+speed),
            Note(command: .Tap, at: 20.6+speed),
///
            Note(command: .Tap, at: 22+speed),
            Note(command: .Tap, at: 22.3+speed),
            Note(command: .Tap, at: 22.6+speed),
            Note(command: .Tap, at: 23+speed),
            Note(command: .Tap, at: 23.3+speed),
            Note(command: .Tap, at: 23.6+speed),

            Note(command: .Tap, at: 25+speed),
            Note(command: .Tap, at: 25.3+speed),
            Note(command: .Tap, at: 25.6+speed),
            Note(command: .Tap, at: 26+speed),
            Note(command: .Tap, at: 26.3+speed),
            Note(command: .Tap, at: 26.6+speed),

            Note(command: .Tap, at: 28+speed),
            Note(command: .Tap, at: 28.3+speed),
            Note(command: .Tap, at: 28.6+speed),
            Note(command: .Tap, at: 29+speed),
            Note(command: .Tap, at: 29.3+speed),
            Note(command: .Tap, at: 29.6+speed)
        ]
        lanes[.Rhythm] = [Note(command: .Tap, at: 5.8 + speed), Note(command: .Tap, at: 8.9 + speed), Note(command: .Tap, at: 12.1 + speed), Note(command: .Tap, at: 15.2 + speed), Note(command: .Tap, at: 18.3 + speed), Note(command: .Tap, at: 21.7 + speed), Note(command: .Tap, at: 24.8 + speed), Note(command: .Tap, at: 27.8 + speed), Note(command: .Tap, at: 31 + speed), Note(command: .SwipeDown, at: 32 + speed), Note(command: .SwipeDown, at: 34 + speed), Note(command: .SwipeUp, at: 34.6 + speed), Note(command: .SwipeDown, at: 35.2 + speed), Note(command: .SwipeDown, at: 37.5 + speed), Note(command: .SwipeUp, at: 37.8 + speed), Note(command: .SwipeDown, at: 38.5 + speed), Note(command: .SwipeDown, at: 40.5 + speed), Note(command: .SwipeUp, at: 40.8 + speed), Note(command: .SwipeDown, at: 41.5 + speed), Note(command: .SwipeDown, at: 43.7 + speed), Note(command: .SwipeUp, at: 44 + speed), Note(command: .SwipeDown, at: 44.8 + speed), Note(command: .SwipeDown, at: 46.8 + speed), Note(command: .SwipeUp, at: 47.1 + speed), Note(command: .SwipeDown, at: 47.9 + speed), Note(command: .SwipeDown, at: 50 + speed), Note(command: .SwipeUp, at: 50.3 + speed), Note(command: .SwipeDown, at: 51 + speed), Note(command: .SwipeDown, at: 53 + speed), Note(command: .SwipeUp, at: 53.3 + speed), Note(command: .SwipeDown, at: 54 + speed), Note(command: .SwipeDown, at: 56.3 + speed), Note(command: .SwipeUp, at: 56.6 + speed), Note(command: .SwipeDown, at: 57.4 + speed), Note(command: .SwipeDown, at: 58.5 + speed), Note(command: .SwipeUp, at: 59 + speed), Note(command: .SwipeDown, at: 60.7 + speed), Note(command: .SwipeDown, at: 61.3 + speed), Note(command: .SwipeUp, at: 61.8 + speed), Note(command: .SwipeDown, at: 63.7 + speed), Note(command: .SwipeDown, at: 64 + speed), Note(command: .SwipeDown, at: 65.2 + speed), Note(command: .SwipeDown, at: 65.6 + speed), Note(command: .SwipeDown, at: 66 + speed), Note(command: .SwipeUp, at: 66.5 + speed)]
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
