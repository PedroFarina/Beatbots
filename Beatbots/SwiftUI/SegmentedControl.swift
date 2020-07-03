//
//  SegmentedControl.swift
//  Beatbots
//
//  Created by Pedro Giuliano Farina on 03/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import SwiftUI
public struct SegmentedControl: View {
    init(_ options: String..., selectedIndex: Int = 0) {
        self.options = options
        self._selectedIndex = State(initialValue: selectedIndex)
    }
    init(_ options: String..., selectedIndex: Int = 0, didSelect: @escaping (String) -> Void) {
        self.options = options
        self._selectedIndex = State(initialValue: selectedIndex)
        self.didSelect = didSelect
    }
    private var didSelect: ((String) -> ())? =  nil
    private let options: [String]
    @State public private(set) var selectedIndex: Int
    public var selectedOption: String {
        return options[selectedIndex]
    }
    public var body: some View {
        Button(action: {
            if self.selectedIndex + 1 == self.options.count {
                self.selectedIndex = 0
            } else {
                self.selectedIndex += 1
            }
            self.didSelect?(self.selectedOption)
        }) {
            HStack(alignment: .center, spacing: 0) {
                ForEach(0..<options.count) {
                    Text(self.options[$0]).foregroundColor(self.textColorFor($0)).padding().background(self.roundedCornerFor($0))
                }
            }
        }
    }

    private func roundedCornerFor(_ index: Int) -> RoundedCorners {
        if index == 0 {
            return RoundedCorners(color: backgroundColorFor(index), tl: 10, tr: 0, bl: 10, br: 0)
        } else if index == options.count - 1 {
            return RoundedCorners(color: backgroundColorFor(index), tl: 0, tr: 10, bl: 0, br: 10)
        }
        return RoundedCorners(color: backgroundColorFor(index), tl: 0, tr: 0, bl: 0, br: 0)
    }

    private func backgroundColorFor(_ index: Int) ->  Color {
        return isIndexSelected(index) ? .green : .gray
    }

    private func textColorFor(_ index: Int) -> Color {
        return isIndexSelected(index) ? .black : .white
    }

    private func isIndexSelected(_ index: Int) -> Bool {
        return selectedIndex == index
    }
}

#if DEBUG
struct SegmentedControl_Previews: PreviewProvider {
    static var previews: some View {
        SegmentedControl("Option", "Option2", "Option3", "Option4", selectedIndex: 0)
    }
}
#endif