//
//  ViewOrder.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 5/21/24.
//

import SwiftUI

struct ViewOrder: View {
    let order: OrderModel
    
    init(order: OrderModel) {
        self.order = order
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        Text(order.orderId)
    }
}

//#Preview {
//    ViewOrder()
//}
