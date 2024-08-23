//
//  CustomerList.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 7/25/24.
//

import Foundation
import SwiftData
import SwiftUI

//
// struct CustomerListConfig  {
//    // VID: 4:20-6:06 https://developer.apple.com/videos/play/wwdc2020/10040/
//    // VID: 7:00 = 8:00 explains binding perfectly, allows write access when you pass the prop down the hiearchy. Changes in for this prop in the child view also changes the prop in parent view @Binding var
//     var shouldNavigate: Bool = false
//     var isPopupPresented: Bool = false
//     var loggedInCustomer: Customer? = nil
//
////    mutating func presentCreate(){
////        return self.isPopupPresented = true
////    }
//
// }
struct CustomerList: View {
    @Environment(\.modelContext) private var context // how to CRUD state
    @Query private var customers: [Customer]
    @State private var isPopupPresented: Bool = false
    @State var shouldNavigate: Bool = false
    //   @State private var customerListConfig = CustomerListConfig()
    @EnvironmentObject var appState: AppStateModel

    var body: some View {
        NavigationStack {
            List {
                ForEach(customers, id: \.id) { customer in
                    CustomNavigationLink(destination: CustomerMainScreen(customer: customer), title: customer.name) {}
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

    func create() {
        isPopupPresented = true
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
    @Environment(\.modelContext) private var context // how to CRUD state
    @State private var nameInput: String = ""
    @EnvironmentObject var appState: AppStateModel

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

    private func create() {
        if nameInput == "" {
            return
        }
        let newCustomer = Customer(name: nameInput)
        context.insert(newCustomer)
        do {
            try context.save()
            isPopupPresented = false
            appState.displayNotification {
                Text("\(newCustomer.name) created!")
            }
        } catch {
            print("Error creating customer: \(newCustomer.name)")
        }
    }
}

#Preview {
    CustomerList().modelContainer(for: [Customer.self, Order.self], inMemory: true).environmentObject(AppStateModel())
}
