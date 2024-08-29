//
//  OrderViewModel.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 8/29/24.
//

import Foundation
import SwiftUI

class OrderViewModel {
    var order: Order

    init(_ order: Order) {
        self.order = order
    }

    func chipColor() -> Color {
        return order.inProgess() || order.delivered() ? .green : order.claimed() ? .blue : .red
    }
}
