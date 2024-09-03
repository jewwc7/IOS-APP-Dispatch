//
//  OrderDetails.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 9/3/24.
//

import Foundation
import SwiftUI

struct OrderDetails: View {
    var order: Order /* ? = createOrders(customer: Customer(name: "Jackie")) */
    var pickup: Pickup
    var dropoff: Dropoff
    var errorManager = ErrorManager()
    @State private var currentStatus: OrderStatus = .unassigned
    @State private var popIsPresented: Bool = false
    
    var orderViewModel: OrderViewModel
    
    init(order: Order) {
        self.order = order
        self.pickup = order.pickup
        self.dropoff = order.dropoff
        self.orderViewModel = OrderViewModel(order)
    }
    
    var body: some View {
        VStack {
            ProgressView(value: orderViewModel.progressValue, total: 1.0)
                .progressViewStyle(StepperProgressViewStyle(stepCount: order.claimedStatuses.count))

            TextChip(title: order.statusTexts[order.status] ?? "missing key", bgColor: orderViewModel.chipColor, font: .subheadline)
            
//                HStack {
//                    ForEach(OrderStatus.allCases, id: \.self) { status in
//                        Button(action: {
//                            currentStatus = status
//                        }) {
//                            Text(status.rawValue.capitalized)
//                                .padding(5)
//                                .background(Color.blue)
//                                .foregroundColor(.white)
//                                .cornerRadius(5)
//                        }
//                    }
//                }
  
            //  .padding()
            // Buttons to change order status
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 10) {
                Button(action: {
                    _ = order.unassign()
                }) {
                    Text("Unassign")
                }
                Button(action: {
                    order.status = OrderStatus.claimed.rawValue
                }) {
                    Text("Claim")
                }
                Button(action: {
                    order.status = OrderStatus.enRouteToPickup.rawValue
                }) {
                    Text("En Route to Pickup")
                }
                Button(action: {
                    order.status = OrderStatus.atPickup.rawValue
                }) {
                    Text("At Pickup")
                }
                Button(action: {
                    order.status = OrderStatus.enRouteToDropoff.rawValue
                }) {
                    Text("En Route to Dropoff")
                }
                Button(action: {
                    order.status = OrderStatus.atDropoff.rawValue
                }) {
                    Text("At Dropoff")
                }
                Button(action: {
                    order.status = OrderStatus.delivered.rawValue
                }) {
                    Text("Delivered")
                }
                Button(action: {
                    order.status = OrderStatus.canceled.rawValue
                }) {
                    Text("Cancel")
                }
                Button(action: {
                    order.transitionToNextStatus()
                }) {
                    Text("Next state")
                }
            }
            .padding()
            .buttonStyle(BorderlessButtonStyle())
 
            NavigationView {
                List {
                    Section(header: TextChip(title: "Pickup", bgColor: .gray, font: .footnote)) {
                        VStack(alignment: .leading) {
                            Text("Organization")
                            Text(pickup.company).bold()
                        }.padding(.vertical, 2)
                    
                        VStack(alignment: .leading) {
                            Text("Address")
                            Text(pickup.fullAddressSpaced).bold()
                        }.padding(.vertical, 2)
                    
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Contact name")
                                Text(pickup.contactName).bold()
                            }
                            VStack(alignment: .leading) {
                                Text("Phone")
                                Text(pickup.phoneNumber).bold()
                            }
                        }
                        .padding(.vertical, 2)
                        .padding(.vertical, 2)
                        VStack(alignment: .leading) {
                            Text("Delivers by")
                            Text(formattedDate(order.pickup.dueAt)).font(.subheadline).bold()
                        }
                    }
                
                    Section(header: TextChip(title: "Dropoff", bgColor: .gray, font: .footnote)) {
                        VStack(alignment: .leading) {
                            Text("Organization")
                            Text(dropoff.company).bold()
                        }.padding(.vertical, 2)
                    
                        VStack(alignment: .leading) {
                            Text("Address")
                            Text(dropoff.fullAddressSpaced).bold()
                        }.padding(.vertical, 2)
                    
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Contact name")
                                Text(dropoff.contactName).bold()
                            }
                            VStack(alignment: .leading) {
                                Text("Phone")
                                Text(dropoff.phoneNumber).bold()
                            }
                        }
                        .padding(.vertical, 2)
                        VStack(alignment: .leading) {
                            Text("Delivers by")
                            Text(formattedDate(order.dropoff.dueAt)).font(.subheadline).bold()
                        }
                    }
                }
                .listStyle(GroupedListStyle())
         
            }.toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button("", systemImage: "plus") {
//                        print("Edit order!!")
//                    }
//                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        popIsPresented = true
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Order Details")
            .overlay(
                MyAlert(
                    isPresented: $popIsPresented,
                    title: "Cancel Order",
                    message: "Are you sure you want to cancel the order?",
                    onYes: {
                        let response = order.cancel()
                        if response.result != .success {
                            errorManager.handleError(BaseError(type: .ValidationError, message: "Can't cancel order"))
                        }
                        popIsPresented = false
                     
                    },
                    onNo: {
                        popIsPresented = false
                        print("Order not canceled")
                    }
                ).animation(.easeInOut, value: popIsPresented)
            )
        }
    }
}

struct StepperProgressViewStyle: ProgressViewStyle {
    var stepCount: Int
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            ForEach(0 ..< stepCount, id: \.self) { index in
               
                Circle()
                    .fill(index < Int(configuration.fractionCompleted! * Double(stepCount)) ? Color.blue : Color.gray)
                    .frame(width: 10, height: 10)
                
                if index < stepCount - 1 {
                    Rectangle()
                        .fill(index < Int(configuration.fractionCompleted! * Double(stepCount)) ? Color.blue : Color.gray)
                        .frame(width: 20, height: 2)
                }
            }
        }
    }
}

// #Preview {
//    OrderDetails().modelContainer(for: [Order.self, Customer.self, Driver.self], inMemory: true).environmentObject(AppStateManager()) // needs to be added to insert the modelContext, making it possible to CRUD state
//    // https://developer.apple.com/tutorials/develop-in-swift/save-data
// }
