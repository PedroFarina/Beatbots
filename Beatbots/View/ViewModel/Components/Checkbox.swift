//
//  Checkbox.swift
//  Beatbots
//
//  Created by Pedro Giuliano Farina on 03/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import SwiftUI

struct Checkbox: View {
    let size: CGFloat = 30
    let color: Color
    let didSelect: ((Bool) -> Void)?

    init(color: Color = .black, initialValue: Bool = false) {
        self.color = color
        didSelect = nil
        _isMarked = State(initialValue: initialValue)
    }

    init(color: Color = .black, initialValue: Bool = false, didChangeValue: @escaping (Bool)-> Void ) {
        self.color = color
        self.didSelect = didChangeValue
        _isMarked = State(initialValue: initialValue)
    }

    @State public private(set) var isMarked:Bool

    var body: some View {
        Button(action:{
            self.isMarked.toggle()
            self.didSelect?(self.isMarked)
        }) {
            Image(systemName: self.isMarked ? "checkmark.square" : "square")
                .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: self.size, height: self.size)
            }.foregroundColor(self.color)
    }
}


#if DEBUG
struct Checkbox_Previews: PreviewProvider {
    static var previews: some View {
        Checkbox()
    }
}
#endif
