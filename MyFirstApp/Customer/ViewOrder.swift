//
//  ViewOrder.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 5/21/24.
//

import SwiftUI

//WHere I left off
// works, but is there a way for me to update the actual order permanetly
// when I naivgate far enough back the order goes back to it's orginal state.
// idk if this observable object is what I want for a consistent state,
//seems more like an intermediate state
struct ViewOrder: View {
    let order: Order

    
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            Text(order.orderId)
            Text(self.order.startedAt == nil ? "Not started" : "Started")
            
            MyButton(title: "Set startedAt") {
                self.startOrder()
            }
        }
      
    }
    
    func startOrder()->Result{
//        print(orderTwo.startedAt)
        do {
            print("starting order", self.order.id)
            self.order.startedAt = Date()
            try self.order.modelContext?.save()
            return .success
        }
        
        catch {
            print(error)
            print("Could not start \(self.order.id)")
            return .failure
            
        }
   
        
    }
}

//#Preview {
//    ViewOrder()
//}
