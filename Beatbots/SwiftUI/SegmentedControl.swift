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
        didSelect = nil
    }
    init(_ options: String..., selectedItem: String, didSelect: @escaping (String) -> Void) {
        self.options = options
        if let index = options.firstIndex(of: selectedItem) {
            self._selectedIndex = State(initialValue: index)
        } else {
            self._selectedIndex = State(initialValue: 0)
        }
        self.didSelect = didSelect
    }
    init(_ options: String..., selectedIndex: Int = 0, didSelect: @escaping (String) -> Void) {
        self.options = options
        self._selectedIndex = State(initialValue: selectedIndex)
        self.didSelect = didSelect
    }
    private let didSelect: ((String) -> ())?
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
            return RoundedCorners(backgroundColor: backgroundColorFor(index), strokeColor: strokeColorFor(index), tl: 10, tr: 0, bl: 10, br: 0)
        } else if index == options.count - 1 {
            return RoundedCorners(backgroundColor: backgroundColorFor(index), strokeColor: strokeColorFor(index), tl: 0, tr: 10, bl: 0, br: 10)
        }
        return RoundedCorners(backgroundColor: backgroundColorFor(index), strokeColor: strokeColorFor(index), tl: 0, tr: 0, bl: 0, br: 0)
    }

    private func backgroundColorFor(_ index: Int) ->  Color {
        return isIndexSelected(index) ? Color(UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.75)) : .clear
    }

    private func strokeColorFor(_ index: Int) -> Color {
        return Color(UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.75))
    }

    private func textColorFor(_ index: Int) -> Color {
        return isIndexSelected(index) ? .white : .black
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
