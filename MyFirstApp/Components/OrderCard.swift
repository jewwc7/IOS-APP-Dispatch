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

import SwiftUI
import Foundation // how I use random number
import SwiftData


struct OrderCard: View {
    var order: Order
    var driver: Driver
    
    var body: some View {
        
        let buttonFrame = (Frame(height: 40, width:100))
        let width = 340.0
        
        VStack {
            
            VStack {
                Text(order.orderId)
                Text(order.pickupLocation).font(.system(size: 24)).bold()
                Text("$\(String(order.pay))").foregroundColor(.green).font(.system(size: 24))
            }.padding(24).foregroundColor(.black).frame(width: width)
            
            HStack {
                // the order od modifieres matters
                
                MyButton(title:"Accept", onPress: claim, backgroundColor: Color.blue, image: "checkmark",frame: buttonFrame)
                
                Spacer() //how to space evenly
                
                MyButton(title:"Decline", onPress: decline, backgroundColor: Color.red, image: "xmark", frame: buttonFrame)
                
                
            }.frame(width: 60).padding(20)
            
        }.background(.white, in: RoundedRectangle(cornerRadius: 8)).shadow(radius: 4).frame(width: width)
    }
    
    func claim(){
        print("Order \(order.orderId) accepted")
        driver.handleOrderAction(action: DriverOrderAction.claim, order: order)
    }
    func decline(){
        // can add an driversThatdelcinedArray and not show the drivers that delcined that order
        print("Order \(order.orderId) declined")
       
    }
}




// What I'll do for state next is
// Create a loggedInUser
//add orders to cart
//if order is in cart instead of displaying decline, display remove
//instead of Accept, display accepted with a green background
//Pressing cart navigates to a page that shows what orders you;ve taken
//make this a lift view.
//can remove orders from here too

//Add a button that creates new orders
//they appear in list view, with animation

