//
//  StateController.swift
//  Beatbots
//
//  Created by Pedro Giuliano Farina on 03/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import SwiftUI

public protocol StateController: class {
    func getState() -> GameState
    func setState(to state: GameState)
}

public protocol StateObserver: class {
    func stateChangedTo(_ state: GameState)
}

public class StateHolder: ObservableObject, StateController {
    @Published var state: GameState = .StartMenu
    var observers: [StateObserver] = []

    public func getState() -> GameState {
        return state
    }

    public func setState(to state: GameState) {
        DispatchQueue.main.async {
            self.state = state
            self.notify()
        }
    }

    private func notify() {
        for observer in observers {
            observer.stateChangedTo(state)
        }
    }

    func subscribe(_ observer: StateObserver) {
        observers.append(observer)
    }
    func unsubscribe(_ observer: StateObserver) {
        if let index = observers.firstIndex(where: {$0 === observer}) {
            observers.remove(at: index)
        }
    }
}
