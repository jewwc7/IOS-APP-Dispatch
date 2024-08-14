//
//  AvailableOrderScreen.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 5/8/24.
//

import SwiftUI
import SwiftData

///
//Create seeds and buttons to create and destry seeds
/////
///
//Make a card for the driver, allow them to release, start/end pickup and dropp off
//Make route creator-> just adds all current days orders and sorts them by etaAt
//Update the information the customer sees when they click their created orded.
    // just make the UI look better
//Make UI look better overall, add loading states, error/success messages
struct AvailableOrderScreen: View {
    @State private var isLoggedOn = true
    @State private var numberOfOrdersInCart = 0
    
    @Environment(\.modelContext) private var context //how to CRUD state
    @Query private var ordersFromModel: [Order]
    @EnvironmentObject var appState: AppStateModel
    
    
    var body: some View {
        let unclaimedOrders = ordersFromModel.filter { $0.driver == nil }
        
        if let loggedInDriver = appState.loggedInDriver {
            NavigationView {
            VStack{
                HStack(alignment: .center) {
                    ZStack {
                        NavigationLink(destination: RouteScreen()){
                            Image(systemName: "cart.circle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                        }
                     
                        
                        
                        if loggedInDriver.orders.count == 0 {
                            EmptyView()
                        } else {
                            withAnimation {
                                Text("\(loggedInDriver.numberOfOrders())") // Display your floating number
                                    .font(.system(size: 16)) // Set the font size
                                    .fontWeight(.bold) // Set the font weight if needed
                                    .foregroundColor(.white) // Set the text color
                                    .padding(8) // Add padding around the text
                                    .background(Color.blue) // Set the background color
                                    .clipShape(Circle()) // Clip the text into a circle shape
                                    .offset(x: 16, y: -16) // Offset the text position relative to the image
                            }
                         
                        }
                        
                    }
                    
                    
                    Toggle("", isOn: $isLoggedOn).toggleStyle(SwitchToggleStyle(tint: .blue))
                    
                }
                

                    Text("Available Orders")
                        .font(.title)
                        .fontWeight(.semibold).frame(maxWidth: .infinity, alignment: .leading)
                
           
                
                ScrollView {
                    
      
                    
                    VStack {
                        // ForEach needs to identify its contents in order to perform layout, successfully delegate gestures to child views and other tasks.
                        // https://stackoverflow.com/questions/69393430/referencing-initializer-init-content-on-foreach-requires-that-planet-c
                        ForEach(unclaimedOrders, id: \.orderId) { order in
                            AvailableOrderCard(order:order, driver: loggedInDriver) // This is the view returned for each item in the array
                        }
                    }
                }
                
                
            }.padding(16)
            }
        }else {
            Text("No logged in driver")
        }

        
    }
    
    func addOrderToCart(order:Order){
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
    AvailableOrderScreen().modelContainer(for: [Order.self, Customer.self], inMemory: true).environmentObject(AppStateModel())
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

