//
//  StateController.swift
//  Beatbots
//
//  Created by Pedro Giuliano Farina on 03/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

public protocol StateController {
    func getState() -> GameState
    func setState(to state: GameState)
}


