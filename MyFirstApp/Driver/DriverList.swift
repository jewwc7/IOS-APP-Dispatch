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
    @Query private var drivers: [Driver]
    @State private var isPopupPresented: Bool = false
    @State var shouldNavigate: Bool = false
 //   @State private var customerListConfig = CustomerListConfig()
    @EnvironmentObject var appState: AppStateModel
   
    var body: some View {
        NavigationStack {
            List {
                ForEach(drivers,  id: \.id){ driver in
                    @State var loggedInDriver: Driver = driver // just to bind it
                    
                    CustomNavigationLink(destination: AvailableOrderScreen(), title: loggedInDriver.name) {
                        logIn(driver: loggedInDriver)
                    }
                    
                }
                  }.navigationTitle("Driver List")
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
            DriverPopupView(isPopupPresented: $isPopupPresented)
        }
    }
    
    func create(){
        isPopupPresented = true
    }
    func logAllOut() {
        print("loggin out all customers")
        drivers.forEach { driver in
            driver.isLoggedIn = false
        }
    }
    func logIn(driver: Driver){
        logAllOut()
        let result = driver.login()
        if(result == .success){
            appState.loginDriver(driver: driver)
            shouldNavigate = true
        }
    }
    
    private func deleteCustomer(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
               // print(customers[index])
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
        print(context.self)
        do {
            try context.save()
            isPopupPresented = false
        } catch {
            print("Error creating driver: \(newDriver.name)")
        }
    }
}



#Preview {
    DriverList().modelContainer(for: [Customer.self, Order.self, Driver.self], inMemory: true).environmentObject(AppStateModel())
}



