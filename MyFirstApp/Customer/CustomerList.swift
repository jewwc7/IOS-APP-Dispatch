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

enum CustomerSortOrder: String, Identifiable, CaseIterable {
    case name, id, totalNumberOfOrders

    var id: Self {
        self
    }
}

struct CustomerListView: View {
    @Environment(\.modelContext) private var context // how to CRUD state
    @Query private var customers: [Customer]
    @State private var isPopupPresented: Bool = false
    @State var shouldNavigate: Bool = false
    //   @State private var customerListConfig = CustomerListConfig()
    @EnvironmentObject var appState: AppStateManager
    @State private var sortOrder: CustomerSortOrder = .name

    var body: some View {
        NavigationStack {
            Picker("", selection: $sortOrder) {
                ForEach(CustomerSortOrder.allCases) { sortOrder in
                    Text("Sort by \(sortOrder.rawValue)").tag(sortOrder)
                }
            }.buttonStyle(.bordered)
            CustomerList(sortOrder: sortOrder)
                .navigationTitle("Customer List")
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

struct CustomerList: View {
    @Environment(\.modelContext) private var context // how to CRUD state
    @Query private var customers: [Customer]

    init(sortOrder: CustomerSortOrder) {
        let sortDescriptors: [SortDescriptor<Customer>] = switch sortOrder {
        case .name:
            [SortDescriptor(\Customer.name), SortDescriptor(\Customer.totalNumberOfOrders, order: .reverse)]
        case .id:
            [SortDescriptor(\Customer.id), SortDescriptor(\Customer.totalNumberOfOrders, order: .reverse)]
        case .totalNumberOfOrders:
            [SortDescriptor(\Customer.totalNumberOfOrders, order: .reverse)]
        }

        _customers = Query(sort: sortDescriptors)
    }

    var body: some View {
        List {
            ForEach(customers, id: \.id) { customer in
                NavigationLink(destination: CustomerMainScreen(customer: customer)) {
                    CustomNavigationLinkLabel(number: customer.totalNumberOfOrders, name: customer.name)
                }
//                CustomNavigationLink(destination: CustomerMainScreen(customer: customer), title: customer.name) {}
            }
        }
    }
}

struct CustomNavigationLinkLabel: View {
    var number: Int
    var name: String

    var body: some View {
        HStack {
            Text(name)
            Spacer()
            VStack(alignment: .trailing) {
                Text("# orders")
                    .font(.caption2)
                    .foregroundColor(.gray)
                ZStack {
                    TextChip(title: String(number), font: .footnote)
                }
            }
        }
    }
}

struct PopupView: View {
    // adding the @Binding with var is how you add mandtory props, llok @CustomerListConfig comments
    @Binding var isPopupPresented: Bool
    @Environment(\.modelContext) private var context // how to CRUD state
    @State private var nameInput: String = ""
    @EnvironmentObject var appState: AppStateManager
    var notificationManager = NotificationManager()

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
            notificationManager.displayNotification {
                Text("\(newCustomer.name) created!").foregroundColor(.white).font(.footnote).padding()
            }
        } catch {
            print("Error creating customer: \(newCustomer.name)")
        }
    }
}

// #Preview {
//    CustomerList().modelContainer(for: [Customer.self, Order.self], inMemory: true).environmentObject(AppStateManager())
// }
