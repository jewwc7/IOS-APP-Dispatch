//
//  OrderCard.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 8/2/24.
//

//
//  AvailableOrderScreen.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 5/8/24.
//

import Foundation // how I use random number
import SwiftData
import SwiftUI

struct AvailableOrderCard: View {
    var order: Order
    var driver: Driver
    
    var body: some View {
        let buttonFrame = Frame(height: 40, width: 100)
        let width = 340.0
        
        VStack {
            VStack {
                Text(order.orderId)
                Text(order.pickupLocation).font(.system(size: 24)).bold()
                Text("$\(String(order.pay))").foregroundColor(.green).font(.system(size: 24))
            }.padding(24).foregroundColor(.black).frame(width: width)
            
            HStack {
                // the order od modifieres matters
                
                MyButton(title: "Accept", onPress: claim, backgroundColor: Color.blue, image: "checkmark", frame: buttonFrame)
                
                Spacer() // how to space evenly
                
                MyButton(title: "Decline", onPress: decline, backgroundColor: Color.red, image: "xmark", frame: buttonFrame)
                
            }.frame(width: 60).padding(20)
            
        }.background(.white, in: RoundedRectangle(cornerRadius: 8)).shadow(radius: 4).frame(width: width)
    }
    
    func claim() {
        print("Order \(order.orderId) accepted")
        driver.handleOrderAction(action: DriverOrderAction.claim, order: order)
    }

    func decline() {
        print("Order \(order.orderId) declined")
    }
}

// #Preview {
//    ModelPreview { order in
//        AvailableOrderCard(order: order, driver: Driver(name: "Hank"))
//    }.environmentObject(AppStateModel())
// }
