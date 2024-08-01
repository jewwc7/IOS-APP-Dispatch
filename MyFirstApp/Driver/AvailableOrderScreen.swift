//
//  AvailableOrderScreen.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 5/8/24.
//

import SwiftUI
import Foundation // how I use random number
import SwiftData


struct AvailableOrderScreen: View {
    @State private var isLoggedOn = true
    @State private var numberOfOrdersInCart = 0
    
    @Environment(\.modelContext) private var context //how to CRUD state
    @Query private var ordersFromModel: [Order]
    
    var body: some View {
        let unclaimedOrders = ordersFromModel.filter { $0.status == OrderStatus.open }
        
        VStack{
            HStack(alignment: .center) {
                ZStack {
                    Image(systemName: "cart.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                    
                    
                    if numberOfOrdersInCart < 1 {
                        EmptyView()
                    } else {
                        
                        Text("\(numberOfOrdersInCart)") // Display your floating number
                            .font(.system(size: 16)) // Set the font size
                            .fontWeight(.bold) // Set the font weight if needed
                            .foregroundColor(.white) // Set the text color
                            .padding(8) // Add padding around the text
                            .background(Color.blue) // Set the background color
                            .clipShape(Circle()) // Clip the text into a circle shape
                            .offset(x: 16, y: -16) // Offset the text position relative to the image
                    }
                    
                }
                
                
                Toggle("", isOn: $isLoggedOn).toggleStyle(SwitchToggleStyle(tint: .blue))
                
            }
            

                Text("Orders")
                    .font(.title)
                    .fontWeight(.semibold).frame(maxWidth: .infinity, alignment: .leading)
            
       
            
            ScrollView {
                
  
                
                VStack {
                    // ForEach needs to identify its contents in order to perform layout, successfully delegate gestures to child views and other tasks.
                    // https://stackoverflow.com/questions/69393430/referencing-initializer-init-content-on-foreach-requires-that-planet-c
                    ForEach(unclaimedOrders, id: \.orderId) { order in
                        OrderCard(order:order, onAccept: addOrderToCart, onDecline: removeOrderFromCart) // This is the view returned for each item in the array
                    }
                }
            }
            
            
        }.padding(16)
        
    }
    
    func addOrderToCart(){
        withAnimation {
            numberOfOrdersInCart += 1
        }
        
    }
 
    func removeOrderFromCart(){
        withAnimation {
            numberOfOrdersInCart = numberOfOrdersInCart - 1
        }
        
    }
    
}

#Preview {
    AvailableOrderScreen()
}


struct OrderCard: View {
    var order: Order
    var onAccept:(() -> Void)? //how to make functions optional
    var onDecline:(() -> Void)?
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
                
                MyButton(title:"Accept", onPress: accept, backgroundColor: Color.blue, image: "checkmark",frame: buttonFrame)
                
                Spacer() //how to space evenly
                
                MyButton(title:"Decline", onPress: decline, backgroundColor: Color.red, image: "xmark", frame: buttonFrame)
                
                
            }.frame(width: 60).padding(20)
            
        }.background(.white, in: RoundedRectangle(cornerRadius: 8)).shadow(radius: 4).frame(width: width)
    }
    
    func accept(){
        print("Order \(order.orderId) accepted")
        if  onAccept != nil {
            onAccept!()
        }
        // onAccept != nil ? onAccept() :  print("hi")
        
    }
    func decline(){
        print("Order \(order.orderId) declined")
        if  onDecline != nil {
            onDecline!() //find a better way to do this
        }
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

