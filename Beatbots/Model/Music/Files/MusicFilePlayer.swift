//
//  FilePlayer.swift
//  Beatbots
//
//  Created by Pedro Giuliano Farina on 16/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import AVFoundation

public class MusicFilePlayer {
    static var backgroundAudioPlayer: AVAudioPlayer = AVAudioPlayer()

    static func playSounds(fileName: String, ext: String, looped: Bool = false) {
        if let path = Bundle.main.path(forResource: fileName, ofType: ext) {
            let url = URL(fileURLWithPath: path)
            do{
                backgroundAudioPlayer = try AVAudioPlayer(contentsOf: url)
                backgroundAudioPlayer.numberOfLoops = looped ? -1 : 0
                if backgroundAudioPlayer.prepareToPlay() {
                    backgroundAudioPlayer.play()
                }
            } catch {
            }
        }
    }
}
