//
//  FilePlayer.swift
//  Beatbots
//
//  Created by Pedro Giuliano Farina on 16/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import AVFoundation

public class MusicFilePlayer {
    public static var players: [AVAudioPlayer] = [AVAudioPlayer(), AVAudioPlayer(), AVAudioPlayer(), AVAudioPlayer()]

    static func setup() {
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setCategory(.playback)
        try? audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        if let path = Bundle.main.path(forResource: "loop", ofType: "wav") {
            let url = URL(fileURLWithPath: path)
            players[0] = (try? AVAudioPlayer(contentsOf: url)) ?? players[0]
        }
    }

    public static func now() -> TimeInterval {
        return players[0].deviceCurrentTime
    }

    static func playInBackground(fileName: String, ext: String, looped: Bool = false, at time: TimeInterval? = now()) {
        if let path = Bundle.main.path(forResource: fileName, ofType: ext) {
            let url = URL(fileURLWithPath: path)
            setPlayer(0, with: url, looped: looped, at: time)
        }
    }

    private static func setPlayer(_ index: Int, with url: URL, looped: Bool, at time: TimeInterval? = nil) {
        do {
            players[index] = try AVAudioPlayer(contentsOf: url)
            players[index].numberOfLoops = looped ? -1 : 0
            if players[index].prepareToPlay() {
                if let time = time {
                    players[index].play(atTime: time)
                } else {
                    players[index].play()
                }
            }
        } catch {

        }
    }

    static func playInPart(fileName: String, ext: String, part: MusicPart, at time: TimeInterval) {
        if let path = Bundle.main.path(forResource: "\(fileName)\(part.rawValue)", ofType: ext) {
            let url = URL(fileURLWithPath: path)
            setPlayer(part.getIndex() + 1, with: url, looped: false, at: time)
        }
    }

    static func setVolume(_ volume: Float, on part: MusicPart) {
        players[part.getIndex() + 1].volume = volume
    }

    static func pause() {
        players.forEach({$0.pause()})
    }

    static func resume() {
        players.forEach({$0.play()})
    }

    static func isBackgroundPlaying() -> Bool {
        return players[0].isPlaying
    }
    static func isPlaying(on part: MusicPart) -> Bool {
        return players[part.getIndex() + 1].isPlaying
    }

    static func stopPlaying() {
        DispatchQueue.concurrentPerform(iterations: 4) { (i) in
            players[i].stop()
        }
    }
}
