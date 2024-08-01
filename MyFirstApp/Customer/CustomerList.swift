//
//  CustomerList.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 7/25/24.
//

import Foundation
import SwiftUI
import SwiftData

enum ActionState: Int {
    case loggedOut = 0
    case loggedIn = 1
}

struct CustomerListConfig  {
    // VID: 4:20-6:06 https://developer.apple.com/videos/play/wwdc2020/10040/
    // VID: 7:00 = 8:00 explains binding perfectly, allows write access when you pass the prop down the hiearchy. Changes in for this prop in the child view also changes the prop in parent view @Binding var
     var shouldNavigate: Bool = false
     var isPopupPresented: Bool = false
     var loggedInCustomer: Customer? = nil
    
    mutating func presentCreate(){
        return self.isPopupPresented = true
    }

}
struct CustomerList: View {
    @Environment(\.modelContext) private var context //how to CRUD state
    @Query private var customers: [Customer]
    @State private var isPopupPresented: Bool = false
    @State var shouldNavigate: Bool = false
    @State private var customerListConfig = CustomerListConfig()
    @EnvironmentObject var appState: AppStateModel
    
    var body: some View {
        // #TODo: Add popup Create ->Pop Up=> enter needed info -> save. THink portion below has this as well as edit feature
        //# TODO: create sample data for customers, follow apple guide portion I am in
   
        
        NavigationStack {
            List {
                ForEach(customers,  id: \.id){ customer in
                    @State var loggedInCustomer: Customer = customer // just to bind it
                    
                    CustomNavigationLink(destination: CustomerMainScreen(loggedInCustomer: $loggedInCustomer), title: customer.name) {
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
        print("loggin out all customers")
        customers.forEach { customer in
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
               // print(customers[index])
                context.delete(customers[index])
            }
        }
    }
    
}

struct PopupView: View {
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
        let newCustomer = Customer(name:nameInput)
        context.insert(newCustomer)
        do {
            try context.save()
            isPopupPresented = false
        } catch {
            print("Error creating customer: \(newCustomer.name)")
        }
    }
}



#Preview {
    CustomerList().modelContainer(for: Customer.self, inMemory: true)
}

// why does this screen show up as a little blue icon when swiping to it from main app?
