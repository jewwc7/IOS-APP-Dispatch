//
//  CustomerMainScreen.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 5/21/24.
//

import SwiftUI
import SwiftData

struct CustomerMainScreen: View {
    let list:[ListOptions] = [
        ListOptions(title: "Create Order", destination: CreateOrderScreen()),
        ListOptions(title: "My Created Orders", destination: MyCreatedOrders())
    ]
    @Binding var loggedInCustomer: Customer
    @Environment(\.modelContext) private var context //how to CRUD state
    @Query private var customers: [Customer]
    @EnvironmentObject var appState: AppStateModel
   
    //check for .loggedInCustomer
    //if not there, display loading spinner, else display list
    
    var body: some View {
        //how to unwrap values safely, in ui.
        if appState.loggedInCustomer != nil  {
            NavigationStack {
                Spacer()
                List {
                    ForEach(list){ item in
                        NavigationLink(destination: AnyView(item.destination)) { //AnyView is dicouraged, but i'll figure that out late
                            //https://stackoverflow.com/questions/75085615/swiftui-providing-destination-for-navigationlink-in-the-view-init-resulting-in
                            Text(item.title)
                        }
                        
                    }.navigationTitle("Hi \(loggedInCustomer.name)").listStyle(.insetGrouped)
                }
            }
            
            
        }else {
            Text("Loading").onAppear(perform: {
                print("No logged in customer")
            })
        }
        
    }
    
    
}


//#Preview {
//   var me =  Customer(name: "Preview Customer")
//    CustomerMainScreen(loggedInCustomer: $me)
//}

struct ListOptions:Identifiable {
    var id = UUID() //needs to be added to make it conform to Identifiable
    var title: String
    var destination: (any View) //how to type a view
}

// why does this screen show up as a little blue icon when swiping to it from main app?
