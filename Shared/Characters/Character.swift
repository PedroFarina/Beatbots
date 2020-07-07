//
//  Characters.swift
//  Beatbots
//
//  Created by Pedro Giuliano Farina on 05/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import SwiftUI

public protocol Character: class {
    static var imagePath: String { get }
    #if os(tvOS)
    var player: Player? { get set }
    #endif
}
