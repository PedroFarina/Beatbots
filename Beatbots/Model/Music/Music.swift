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
            Note(command: .Tap, at: 6+speed),
            Note(command: .Tap, at: 6.4+speed),
            Note(command: .Tap, at: 6.8+speed),
            Note(command: .Tap, at: 7.2+speed),
            Note(command: .Tap, at: 7.6+speed),
            Note(command: .Tap, at: 8+speed),
            Note(command: .Tap, at: 8.4+speed),

            Note(command: .Tap, at: 9.6+speed),
            Note(command: .Tap, at: 10+speed),
            Note(command: .Tap, at: 10.4+speed),
            Note(command: .Tap, at: 10.8+speed),
            Note(command: .Tap, at: 11.2+speed),
            Note(command: .Tap, at: 11.6+speed),

            Note(command: .Tap, at: 12.8+speed),
            Note(command: .Tap, at: 13.2+speed),
            Note(command: .Tap, at: 13.6+speed),
            Note(command: .Tap, at: 14+speed),
            Note(command: .Tap, at: 14.4+speed),
            Note(command: .Tap, at: 14.8+speed),

            Note(command: .Tap, at: 16+speed),
            Note(command: .Tap, at: 16.4+speed),
            Note(command: .Tap, at: 16.8+speed),
            Note(command: .Tap, at: 17.2+speed),
            Note(command: .Tap, at: 17.6+speed),

            Note(command: .Tap, at: 19.2+speed),
            Note(command: .Tap, at: 19.6+speed),
            Note(command: .Tap, at: 20+speed),
            Note(command: .Tap, at: 20.4+speed),
            Note(command: .Tap, at: 20.8+speed),
            Note(command: .Tap, at: 21.2+speed),

            Note(command: .Tap, at: 22.4+speed),
            Note(command: .Tap, at: 22.8+speed),
            Note(command: .Tap, at: 23.2+speed),
            Note(command: .Tap, at: 23.6+speed),
            Note(command: .Tap, at: 24+speed),
            Note(command: .Tap, at: 24.4+speed),

            Note(command: .Tap, at: 25.6+speed),
            Note(command: .Tap, at: 26+speed),
            Note(command: .Tap, at: 26.4+speed),
            Note(command: .Tap, at: 26.8+speed),
            Note(command: .Tap, at: 27.2+speed),
            Note(command: .Tap, at: 27.6+speed),

            Note(command: .Tap, at: 28.8+speed),
            Note(command: .Tap, at: 29.2+speed),
            Note(command: .Tap, at: 29.6+speed),
            Note(command: .Tap, at: 30+speed),
            Note(command: .Tap, at: 30.4+speed),

            Note(command: .Tap, at: 32.2+speed),
            Note(command: .Tap, at: 33+speed),
            Note(command: .Tap, at: 33.5+speed),
            Note(command: .Tap, at: 34+speed),
            Note(command: .Tap, at: 34.5+speed),
            Note(command: .Tap, at: 35+speed),
            Note(command: .Tap, at: 35.5+speed),
            Note(command: .Tap, at: 36.2+speed),
            Note(command: .Tap, at: 37+speed),

            Note(command: .Tap, at: 38.7+speed),

            Note(command: .Tap, at: 39+speed),
            Note(command: .Tap, at: 39.5+speed),
            Note(command: .Tap, at: 40+speed),
            Note(command: .Tap, at: 41.5+speed),

            Note(command: .Tap, at: 42+speed),
            Note(command: .Tap, at: 42.5+speed),
            Note(command: .Tap, at: 43+speed),
            Note(command: .Tap, at: 43.5+speed),
            Note(command: .Tap, at: 44+speed),

            //repeat
            Note(command: .Tap, at: 45.2+speed),
            Note(command: .Tap, at: 46+speed),
            Note(command: .Tap, at: 46.5+speed),
            Note(command: .Tap, at: 47+speed),
            Note(command: .Tap, at: 47.5+speed),
            Note(command: .Tap, at: 48+speed),
            Note(command: .Tap, at: 48.5+speed),
            Note(command: .Tap, at: 49.2+speed),
            Note(command: .Tap, at: 50+speed),

            Note(command: .Tap, at: 51.7+speed),

            Note(command: .Tap, at: 52+speed),
            Note(command: .Tap, at: 52.5+speed),
            Note(command: .Tap, at: 53+speed),
            Note(command: .Tap, at: 54.5+speed),

            Note(command: .Tap, at: 55+speed),
            Note(command: .Tap, at: 55.5+speed),
            Note(command: .Tap, at: 56+speed),
            Note(command: .Tap, at: 56.5+speed),
            Note(command: .Tap, at: 57+speed),

            //end
            Note(command: .Tap, at: 58.4+speed),

            Note(command: .Tap, at: 63.4+speed),
            Note(command: .Tap, at: 63.8+speed),
            Note(command: .Tap, at: 64.2+speed),
            Note(command: .Tap, at: 64.6+speed),
            Note(command: .Tap, at: 65+speed),
            Note(command: .Tap, at: 65.4+speed),
            Note(command: .Tap, at: 65.8+speed),

            Note(command: .Tap, at: 67+speed),
            Note(command: .Tap, at: 67.4+speed),
            Note(command: .Tap, at: 67.8+speed),
            Note(command: .Tap, at: 68.2+speed),
            Note(command: .Tap, at: 68.6+speed),
            Note(command: .Tap, at: 69+speed),

            Note(command: .Tap, at: 70.2+speed),
            Note(command: .Tap, at: 70.6+speed),
            Note(command: .Tap, at: 71+speed),
            Note(command: .Tap, at: 71.4+speed),
            Note(command: .Tap, at: 71.8+speed),
            Note(command: .Tap, at: 72.2+speed),

            Note(command: .Tap, at: 73.4+speed),
            Note(command: .Tap, at: 73.8+speed),
            Note(command: .Tap, at: 74.2+speed),
            Note(command: .Tap, at: 74.6+speed),
            Note(command: .Tap, at: 75+speed),

            Note(command: .Tap, at: 77+speed),
            Note(command: .Tap, at: 77.4+speed),
            Note(command: .Tap, at: 77.8+speed),
            Note(command: .Tap, at: 78.2+speed),
            Note(command: .Tap, at: 78.6+speed),
            Note(command: .Tap, at: 79+speed),

            Note(command: .Tap, at: 80.2+speed),
            Note(command: .Tap, at: 80.6+speed),
            Note(command: .Tap, at: 81+speed),
            Note(command: .Tap, at: 81.4+speed),
            Note(command: .Tap, at: 81.8+speed),
            Note(command: .Tap, at: 82.2+speed),

            Note(command: .Tap, at: 83.4+speed),
            Note(command: .Tap, at: 83.8+speed),
            Note(command: .Tap, at: 84.2+speed),
            Note(command: .Tap, at: 84.6+speed),
            Note(command: .Tap, at: 85+speed),
            Note(command: .Tap, at: 85.4+speed),

            Note(command: .Tap, at: 86.6+speed),
            Note(command: .Tap, at: 87+speed),
            Note(command: .Tap, at: 87.5+speed),
            Note(command: .Tap, at: 87.7+speed),
            Note(command: .Tap, at: 88.2+speed),

            Note(command: .Tap, at: 89.8+speed),
            Note(command: .Tap, at: 90.2+speed),
            Note(command: .Tap, at: 90.6+speed),
            Note(command: .Tap, at: 91+speed),
            Note(command: .Tap, at: 91.4+speed),
            Note(command: .Tap, at: 91.8+speed),

            Note(command: .Tap, at: 92.2+speed),
            Note(command: .Tap, at: 93+speed),
            Note(command: .Tap, at: 93.5+speed),
            Note(command: .Tap, at: 94+speed),
            Note(command: .Tap, at: 94.5+speed),
            Note(command: .Tap, at: 95+speed),
            Note(command: .Tap, at: 95.5+speed),
            Note(command: .Tap, at: 96.2+speed),
            Note(command: .Tap, at: 97+speed),

            Note(command: .Tap, at: 98.7+speed),

            Note(command: .Tap, at: 99+speed),
            Note(command: .Tap, at: 99.5+speed),
            Note(command: .Tap, at: 100+speed),
            Note(command: .Tap, at: 101.5+speed),

            Note(command: .Tap, at: 102+speed),
            Note(command: .Tap, at: 102.5+speed),
            Note(command: .Tap, at: 103+speed),
            Note(command: .Tap, at: 103.5+speed),
            Note(command: .Tap, at: 104+speed),

            //repeat
            Note(command: .Tap, at: 105.2+speed),
            Note(command: .Tap, at: 106+speed),
            Note(command: .Tap, at: 106.5+speed),
            Note(command: .Tap, at: 107+speed),
            Note(command: .Tap, at: 107.5+speed),
            Note(command: .Tap, at: 108+speed),
            Note(command: .Tap, at: 108.5+speed),
            Note(command: .Tap, at: 109.2+speed),
            Note(command: .Tap, at: 110+speed),

            Note(command: .Tap, at: 111.7+speed),

            Note(command: .Tap, at: 112+speed),
            Note(command: .Tap, at: 112.5+speed),
            Note(command: .Tap, at: 113+speed),
            Note(command: .Tap, at: 114.5+speed),

            Note(command: .Tap, at: 115+speed),
            Note(command: .Tap, at: 115.5+speed),
            Note(command: .Tap, at: 116+speed),
            Note(command: .Tap, at: 116.5+speed),
            Note(command: .Tap, at: 117+speed),

            //end
            Note(command: .Tap, at: 118.4+speed),

            Note(command: .Tap, at: 124.6+speed),
            Note(command: .Tap, at: 125+speed),
            Note(command: .Tap, at: 125.4+speed),
            Note(command: .Tap, at: 125.8+speed),
            Note(command: .Tap, at: 126.2+speed),
            Note(command: .Tap, at: 126.6+speed),
            Note(command: .Tap, at: 127+speed),

            Note(command: .Tap, at: 128.2+speed),
            Note(command: .Tap, at: 128.6+speed),
            Note(command: .Tap, at: 129+speed),
            Note(command: .Tap, at: 129.4+speed),
            Note(command: .Tap, at: 129.8+speed),
            Note(command: .Tap, at: 130.2+speed),

            Note(command: .Tap, at: 131.4+speed),
            Note(command: .Tap, at: 131.8+speed),
            Note(command: .Tap, at: 132.2+speed),
            Note(command: .Tap, at: 132.6+speed),
            Note(command: .Tap, at: 133+speed),
            Note(command: .Tap, at: 133.4+speed),

            Note(command: .Tap, at: 134.6+speed),
            Note(command: .Tap, at: 135+speed),
            Note(command: .Tap, at: 135.4+speed),
            Note(command: .Tap, at: 135.8+speed),
            Note(command: .Tap, at: 136.2+speed),

            Note(command: .Tap, at: 137.8+speed),
            Note(command: .Tap, at: 138.2+speed),
            Note(command: .Tap, at: 138.6+speed),
            Note(command: .Tap, at: 139+speed),
            Note(command: .Tap, at: 139.4+speed),
            Note(command: .Tap, at: 139.8+speed),

            Note(command: .Tap, at: 141+speed),
            Note(command: .Tap, at: 141.4+speed),
            Note(command: .Tap, at: 141.8+speed),
            Note(command: .Tap, at: 142.2+speed),
            Note(command: .Tap, at: 142.6+speed),
            Note(command: .Tap, at: 143+speed),

            Note(command: .Tap, at: 144.2+speed),
            Note(command: .Tap, at: 144.6+speed),
            Note(command: .Tap, at: 145+speed),
            Note(command: .Tap, at: 145.4+speed),
            Note(command: .Tap, at: 145.8+speed),
            Note(command: .Tap, at: 146.2+speed),

            Note(command: .Tap, at: 147.4+speed),
            Note(command: .Tap, at: 147.8+speed),
            Note(command: .Tap, at: 148.2+speed),
            Note(command: .Tap, at: 148.6+speed),
            Note(command: .Tap, at: 149+speed),

            Note(command: .Tap, at: 150.6+speed),
            Note(command: .Tap, at: 151+speed),
            Note(command: .Tap, at: 151.4+speed),
            Note(command: .Tap, at: 151.8+speed),
            Note(command: .Tap, at: 152.2+speed),
            Note(command: .Tap, at: 152.6+speed),

            //song's end 3.0
            Note(command: .Tap, at: 155.6+speed),
            Note(command: .Tap, at: 156+speed),
            Note(command: .Tap, at: 156.4+speed),
            Note(command: .Tap, at: 156.8+speed),
            Note(command: .Tap, at: 157.2+speed),
            Note(command: .Tap, at: 157.6+speed),
            Note(command: .Tap, at: 158+speed),

            Note(command: .Tap, at: 159.2+speed),
            Note(command: .Tap, at: 159.6+speed),
            Note(command: .Tap, at: 160+speed),
            Note(command: .Tap, at: 160.4+speed),
            Note(command: .Tap, at: 160.8+speed),
            Note(command: .Tap, at: 161.2+speed),

            Note(command: .Tap, at: 162.4+speed),
            Note(command: .Tap, at: 162.8+speed),
            Note(command: .Tap, at: 163.2+speed),
            Note(command: .Tap, at: 163.6+speed),
            Note(command: .Tap, at: 164+speed),
            Note(command: .Tap, at: 164.4+speed),

            Note(command: .Tap, at: 165.6+speed),
            Note(command: .Tap, at: 166+speed),
            Note(command: .Tap, at: 166.4+speed),
            Note(command: .Tap, at: 166.8+speed),
            Note(command: .Tap, at: 166.2+speed),

            Note(command: .Tap, at: 168.8+speed),
            Note(command: .Tap, at: 169.2+speed),
            Note(command: .Tap, at: 169.6+speed),
            Note(command: .Tap, at: 170+speed),
            Note(command: .Tap, at: 170.4+speed),
            Note(command: .Tap, at: 170.8+speed),

            Note(command: .Tap, at: 172+speed),
            Note(command: .Tap, at: 172.4+speed),
            Note(command: .Tap, at: 172.8+speed),
            Note(command: .Tap, at: 173.2+speed),
            Note(command: .Tap, at: 173.6+speed),
            Note(command: .Tap, at: 174+speed),

            Note(command: .Tap, at: 175.2+speed),
            Note(command: .Tap, at: 175.6+speed),
            Note(command: .Tap, at: 176+speed),
            Note(command: .Tap, at: 176.4+speed),
            Note(command: .Tap, at: 176.8+speed),
            Note(command: .Tap, at: 177.2+speed),

            Note(command: .Tap, at: 178.4+speed),
            Note(command: .Tap, at: 178.8+speed),
            Note(command: .Tap, at: 179.2+speed),
            Note(command: .Tap, at: 179.6+speed),
            Note(command: .Tap, at: 180+speed),

            Note(command: .Tap, at: 181.6+speed),
            Note(command: .Tap, at: 182+speed),
            Note(command: .Tap, at: 182.4+speed),
            Note(command: .Tap, at: 182.8+speed),
            Note(command: .Tap, at: 183.2+speed),
            Note(command: .Tap, at: 183.6+speed),

            Note(command: .Tap, at: 184.2+speed),
            Note(command: .Tap, at: 185+speed),
            Note(command: .Tap, at: 185.5+speed),
            Note(command: .Tap, at: 186+speed),
            Note(command: .Tap, at: 186.5+speed),
            Note(command: .Tap, at: 187+speed),
            Note(command: .Tap, at: 187.5+speed),
            Note(command: .Tap, at: 188.2+speed),
            Note(command: .Tap, at: 189+speed),

            Note(command: .Tap, at: 190.7+speed),

            Note(command: .Tap, at: 191+speed),
            Note(command: .Tap, at: 191.5+speed),
            Note(command: .Tap, at: 192+speed),
            Note(command: .Tap, at: 193.5+speed),

            Note(command: .Tap, at: 194+speed),
            Note(command: .Tap, at: 194.5+speed),
            Note(command: .Tap, at: 195+speed),
            Note(command: .Tap, at: 195.5+speed),
            Note(command: .Tap, at: 196+speed),

            Note(command: .Tap, at: 197.2+speed),
            Note(command: .Tap, at: 198+speed),
            Note(command: .Tap, at: 198.5+speed),
            Note(command: .Tap, at: 199+speed),
            Note(command: .Tap, at: 199.5+speed),
            Note(command: .Tap, at: 200+speed),
            Note(command: .Tap, at: 200.5+speed),
            Note(command: .Tap, at: 201.2+speed),
            Note(command: .Tap, at: 202+speed),

            Note(command: .Tap, at: 203.7+speed),

            Note(command: .Tap, at: 204+speed),
            Note(command: .Tap, at: 204.5+speed),
            Note(command: .Tap, at: 205+speed),
            Note(command: .Tap, at: 206.5+speed),

            Note(command: .Tap, at: 207+speed),
            Note(command: .Tap, at: 207.5+speed),
            Note(command: .Tap, at: 208+speed),
            Note(command: .Tap, at: 208.5+speed),
            Note(command: .Tap, at: 209+speed),

            Note(command: .Tap, at: 210.4+speed)
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
