//
//  CreateOrder.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 5/20/24.
//

import SwiftUI
import SwiftData

struct CreateOrderScreen: View {
    @Query private var orderModelOrders: [Order]
    @Environment(\.modelContext) private var context //how to CRUD state
    @EnvironmentObject var appState: AppStateModel
    
    let inputHeight = 40.0
    @State private var orderNumber: String = ""
    @State private var pickupLocation: String = ""
    @State private var pickupPhoneNumber: String = ""
    @State private var pickupContactName: String = ""
    @State private var pickupCompanyOrOrg: String = ""
    
    @State private var dropoffLocation: String = ""
    @State private var dropoffPhoneNumber: String = ""
    @State private var dropoffContactName: String = ""
    @State private var dropoffCompanyOrOrg: String = ""
    @State private var dropoffNotes: String = ""

    var body: some View {
//        List(orderModelOrders) { order in
//                 HStack {
//                     Text(order.pickupLocation)
//                     Spacer()
//                     Text(order.dropoffLocation)
//                 }
//             }
        VStack{
            Text("Create An Order").bold().font(.title).multilineTextAlignment(.center).padding().shadow(radius: 8)
            
                Form { //forms should not be nested in scrollviews, they are already scrollviews
                    Section(header: Text("Order Information").bold().font(.title2)){
                        TextField("Order Number", text: $orderNumber).frame( height: inputHeight)
                    }
                    Section(header: Text("Pickup").bold().font(.title2)){
                        TextField("Pickup Location", text: $pickupLocation).frame( height: inputHeight)
                        TextField("Phone number", text: $pickupPhoneNumber).frame( height: inputHeight)
                        TextField("Contact name", text: $pickupContactName).frame( height: inputHeight)
                        TextField("Company or Organization", text: $pickupCompanyOrOrg).frame( height: inputHeight)
                    }
                    Section(header: Text("Drop Off").bold().font(.title2)){
                        TextField("Pickup Location", text: $dropoffLocation).frame( height: inputHeight)
                        TextField("Phone number", text: $dropoffPhoneNumber).frame( height: inputHeight)
                        TextField("Contact name", text:$dropoffContactName).frame( height: inputHeight)
                        TextField("Company or Organization", text: $dropoffCompanyOrOrg).frame( height: inputHeight)
                        TextField("Drop-off Notes", text: $dropoffNotes).frame( height: inputHeight * 4)
                    }
                    MyButton(title:"Create",onPress: create, backgroundColor: Color.green, image:"checkmark", frame: (Frame(height: 40))).frame(maxWidth: .infinity)
                    MyButton(title:"Random",onPress: prePopulate, backgroundColor: Color.blue, image:"checkmark", frame: (Frame(height: 40))).frame(maxWidth: .infinity)
                }

     
       
        }
    }
    func printStateVariables() {
          let mirror = Mirror(reflecting: self)
          for child in mirror.children {
              if let label = child.label, label.hasPrefix("_") {
                  print("\(label.dropFirst()): \(child.value)")
              }
          }
      }
    func create(){
        print(context)
        if let customer = appState.loggedInCustomer {
            let newOrder = Order( orderNumber: orderNumber, pickupLocation: pickupLocation, pickupPhoneNumber: pickupPhoneNumber, pickupContactName: pickupContactName, pickupCompanyOrOrg: pickupCompanyOrOrg, dropoffLocation: dropoffLocation, dropoffPhoneNumber: dropoffPhoneNumber, dropoffContactName: dropoffContactName, dropoffCompanyOrOrg:dropoffCompanyOrOrg, pay: 100, customer: customer)
           
            context.insert(newOrder)
            customer.handleOrderAction(action:CustomerOrderAction.place, order:newOrder)
            do {
                try customer.modelContext?.save()
                try context.save()
            } catch {
                print("Error creating order: \(error)")
            }
        }else {
            print("No customer logged in to create the order")
        }

    }
    func prePopulate(){
        orderNumber = "123"
        pickupLocation = "1234 main st"
        pickupPhoneNumber = "281-330-8004"
        pickupContactName = "Mike Jones"
        pickupCompanyOrOrg = "Swishahouse"
        dropoffLocation = "6789 broadway st"
        dropoffPhoneNumber = "904-490-7777"
        dropoffContactName = "Johnny"
        dropoffCompanyOrOrg = "Diamond Boys"
    }
}

#Preview {
    CreateOrderScreen().modelContainer(for: [Order.self, Customer.self], inMemory: true).environmentObject(AppStateModel()) //needs to be added to insert the modelContext, making it possible to CRUD state
    //https://developer.apple.com/tutorials/develop-in-swift/save-data
}



