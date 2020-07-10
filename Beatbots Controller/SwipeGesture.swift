//
//  SwipeGesture.swift
//  Beatbots Controller
//
//  Created by Pedro Giuliano Farina on 10/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import SwiftUI

public struct Swipe {
    public var direction: UISwipeGestureRecognizer.Direction
    public var action: () -> ()
}

public struct SwipeGesture: UIViewRepresentable {
    init(_ swipe: Swipe...) {
        self.swipes = swipe
    }
    var swipes: [Swipe]

    public func makeCoordinator() -> SwipeGesture.MyCoordinator {
        return MyCoordinator()
    }

    public func updateUIView(_ uiView: UIView, context ext: Context) {
    }

    private static var gestureRecognizers: [UIGestureRecognizer] = []
    public func makeUIView(context: Context) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        context.coordinator.swipes = swipes
        for swipe in swipes {
            let swipeRecognizer = UISwipeGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.swipeOccur(_:)))
            swipeRecognizer.direction = swipe.direction
            view.addGestureRecognizer(swipeRecognizer)
        }

        return view
    }

    private func appendRecognizer(_ recognizer: UIGestureRecognizer) {
        SwipeGesture.gestureRecognizers.append(recognizer)
    }

    public class MyCoordinator: NSObject {
        var swipes: [Swipe]?
        @objc func swipeOccur(_ sender: UISwipeGestureRecognizer) {
            if let swipes = swipes {
                for swipe in swipes where swipe.direction == sender.direction {
                    swipe.action()
                }
            }
        }
    }
}
