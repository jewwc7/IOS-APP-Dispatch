//
//  DriverList.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 8/5/24.
//

import Foundation
import SwiftUI
import SwiftData



struct DriverList: View {
    @Environment(\.modelContext) private var context //how to CRUD state
    @Query private var drivers: [Customer]
    @State private var isPopupPresented: Bool = false
    @State var shouldNavigate: Bool = false
 //   @State private var customerListConfig = CustomerListConfig()
    @EnvironmentObject var appState: AppStateModel
   
    var body: some View {
        // #TODo: Add popup Create ->Pop Up=> enter needed info -> save. THink portion below has this as well as edit feature
        //# TODO: create sample data for drivers, follow apple guide portion I am in
       // let filteredOrders = orders.filter { $0.customerId == appState.loggedInCustomer?.id }
        
        NavigationStack {
            List {
                ForEach(drivers,  id: \.id){ customer in
                    @State var loggedInCustomer: Customer = customer // just to bind it
                    
                    CustomNavigationLink(destination: CustomerMainScreen(), title: customer.name) {
                        print("yooo")
                        logIn(customer: customer)
                    }
                    
                }
                  }.navigationTitle("Customer List")
                .toolbar {
//                    ToolbarItem(placement: .navigationBarTrailing) {
//                        EditButton()
//                    } // TODO: Add ability to edit customer
                    ToolbarItem {
                        Button(action: create) {
                            Label("Create", systemImage: "plus")
                        }
                    }
                }
        }.sheet(isPresented: $isPopupPresented) {
            // Your popup view here
            PopupView(isPopupPresented: $isPopupPresented)
        }
    }
    
    func create(){
        isPopupPresented = true
    }
    func logAllOut() {
        print("loggin out all drivers")
        drivers.forEach { customer in
            customer.isLoggedIn = false
        }
    }
    func logIn(customer: Customer){
        logAllOut()
        let result = customer.login()
        if(result == .success){
            appState.login(customer: customer)
            shouldNavigate = true
        }
    }
    
    private func deleteCustomer(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
               // print(drivers[index])
                context.delete(drivers[index])
            }
        }
    }
    
}

struct DriverPopupView: View {
    // adding the @Binding with var is how you add mandtory props, llok @CustomerListConfig comments
    @Binding var isPopupPresented: Bool
    @Environment(\.modelContext) private var context //how to CRUD state
    @State private var nameInput: String = ""
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                    Text("Name")
                        .font(.headline)
                        .padding(.bottom, 2)
                    
                    TextField("Name", text: $nameInput)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                }
                .padding()
            Button(action: create) {
                Label("Create", systemImage: "plus")
            }.padding()
   
            Button(action: {
                // Dismiss the sheet
                isPopupPresented = false
            }) {
                Label("Cancel", systemImage: "minus")
            }
        }
    }
    
    private func create(){
        if nameInput == "" {
            return
        }
        let newDriver = Driver(name:nameInput)
        context.insert(newDriver)
        do {
            try context.save()
            isPopupPresented = false
        } catch {
            print("Error creating driver: \(newDriver.name)")
        }
    }
}



#Preview {
    CustomerList().modelContainer(for: [Customer.self, Order.self, Driver.self], inMemory: true).environmentObject(AppStateModel())
}


#Preview {
    DriverList()
}
