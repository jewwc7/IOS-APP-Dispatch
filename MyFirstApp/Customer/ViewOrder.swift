//
//  ViewOrder.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 5/21/24.
//

import SwiftUI

struct ViewOrder: View {
    var order: Order /* ? = createOrders(customer: Customer(name: "Jackie")) */
    var pickup: Pickup
    var dropoff: Dropoff
    @State private var currentStatus: OrderStatus = .unassigned
    var orderViewModel: OrderViewModel
    
    init(order: Order) {
        self.order = order
        self.pickup = order.pickup
        self.dropoff = order.dropoff
        self.orderViewModel = OrderViewModel(order)
    }
    
    var body: some View {
        let claimedStatuses = order.claimedStatuses
        let chipColor: Color = orderViewModel.chipColor()
        VStack {
            ProgressView(value: progressValue, total: 1.0)
                .progressViewStyle(StepperProgressViewStyle(stepCount: claimedStatuses.count))

            TextChip(title: order.statusTexts[order.status] ?? "missing key", bgColor: chipColor, font: .subheadline)
            
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
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("", systemImage: "plus") {
                        print("Edit order!!")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("", systemImage: "xmark") {
                        print("Cancel order!!")
                    }
                }
            }
            .navigationTitle("Order Details")
        }
    }
    
    private var progressValue: Double {
        // This line attempts to find the index of the currentStatus in the array of all possible OrderStatus cases (OrderStatus.allCases).
        // If currentStatus is not found in OrderStatus.allCases, the guard statement returns 0.0, indicating no //progress.
        // If not claimed ahould be at 0
        let currentStatus = order.claimedStatuses.firstIndex(of: order.comparableStatus)
      
        guard let index = currentStatus else {
            return 0.0
        }
        // I want claimed to start, index is 0 for claim, so need to add 1 to every index
        return Double(index + 1) / Double(order.claimedStatuses.count)
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
//                Button("print") {
//                    h(index: index, stpeCount: stepCount, configuration: configuration)
//                }
            }
        }
    }
    
    func h(index: Int, stpeCount: Int, configuration: Configuration) {
        print(index, stepCount, configuration)
    }
}

// #Preview {
//    ViewOrder().modelContainer(for: [Order.self, Customer.self, Driver.self], inMemory: true).environmentObject(AppStateModel()) // needs to be added to insert the modelContext, making it possible to CRUD state
//    // https://developer.apple.com/tutorials/develop-in-swift/save-data
// }
