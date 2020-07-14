//
//  Pool.swift
//  Beatbots
//
//  Created by Pedro Giuliano Farina on 14/07/20.
//  Copyright © 2020 Pedro Giuliano Farina. All rights reserved.
//

import Foundation

public class Pool<T> {
    private let lockQueue = DispatchQueue(label: "pool.lock.queue")
    private var items = [T]()

    init(_ items: [T]) {
        self.items.reserveCapacity(items.count)
        self.items.append(contentsOf: items)
    }

    func acquire() -> T? {
        if !self.items.isEmpty {
            return self.lockQueue.sync {
                return self.items.remove(at: 0)
            }
        }
        return nil
    }

    func release(_ item: T) {
        self.lockQueue.sync {
            self.items.append(item)
        }
    }
}
