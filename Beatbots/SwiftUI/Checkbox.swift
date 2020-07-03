//
//  Checkbox.swift
//  Beatbots
//
//  Created by Pedro Giuliano Farina on 03/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import SwiftUI

struct Checkbox: View {
    let size: CGFloat
    let color: Color
    let didSelect: ((Bool) -> Void)?

    init(size: CGFloat = 30, color: Color = .black) {
        self.size = size
        self.color = color
        didSelect = nil
    }

    init(size: CGFloat = 30, color: Color = .black, didSelect: @escaping (Bool)-> Void ) {
        self.size = size
        self.color = color
        self.didSelect = didSelect
    }

    @State public private(set) var isMarked:Bool = false

    var body: some View {
        Button(action:{
            self.isMarked.toggle()
            self.didSelect?(self.isMarked)
        }) {
            Image(systemName: self.isMarked ? "checkmark.square" : "square")
                .renderingMode(.original)
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
