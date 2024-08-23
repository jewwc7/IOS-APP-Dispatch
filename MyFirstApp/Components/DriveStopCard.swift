//
//  DriverOrderCard.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 8/5/24.
//

import SwiftData
import SwiftUI

struct DriverStopCard: View {
    @State private var isExpanded: Bool = false
    var stop: Stop // = createOrder()
    
    var body: some View {
        VStack(alignment: .leading) {
            // Header
            HStack {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        Text("Pickup:")
                            .font(.subheadline)
                        Text(stop.fullAddress)
                            .font(.headline)
                    }
                    VStack(alignment: .leading) {
                        Text("Dropoff:")
                            .font(.subheadline)
                        Text(stop.fullAddress)
                            .font(.headline)
                    }.padding(.top, 8)
                
                    HStack(spacing: 20) {
                        Text("Due:")
                        // TODO: use the stops when implemented
                        Text(stop.order?.dueAtFormatted() ?? "Missing due date").font(.headline).foregroundStyle(.red)
                        //  MyChip(text: order.dueAtFormatted())
                    }.padding(.top, 12)
                   
                }.padding()
            
                Spacer()
                
                Button(action: {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }) {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .padding()
                }
            }
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
            
            // Content
            if isExpanded {
                DriveStopCardData(stop: stop).transition(.opacity) // Transition effect when expanding/collapsing
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
        }
        .padding()
//        .background(Color.white)
//        .cornerRadius(10)
//        .shadow(radius: 5)
    }
}

struct DriveStopCardData: View {
    var stop: Stop

    init(stop: Stop) {
        self.stop = stop
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack {
                Text("Pickup info").font(.title2)
            }.padding(.vertical, 2)
            VStack(alignment: .leading) {
                Text("Organization")
                Text(stop.company).bold()
            }.padding(.vertical, 2)
            
            VStack(alignment: .leading) {
                Text("Address")
                Text(stop.fullAddress).bold()
            }.padding(.vertical, 2)
            HStack {
                VStack(alignment: .leading) {
                    Text("Contact name")
                    Text(stop.contactName).bold()
                }
                VStack(alignment: .leading) {
                    Text("Phone")
                    Text(stop.phoneNumber).bold()
                }
            }
            .padding(.vertical, 2)
           
            Divider()
            
            Spacer()
            if let order = stop.order {
                MyButton(title: driverRouteStatus(order.status), onPress: handleOnPress, backgroundColor: Color.blue, image: "checkmark", frame: Frame(height: 40, width: 140)).frame(maxWidth: .infinity).disabled(order.delivered())
            } else {
                MyButton(title: "Can't start Order")
            }
         
        }.padding().overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.blue, lineWidth: 2)
        )
    }
    
    func handleOnPress() {
        withAnimation(.smooth) {
            if let order = stop.order {
                order.handleStatusTransition()
            } else {
                print("stop has no associated order")
            }
        }
    }
    
    func driverRouteStatus(_ status: OrderStatus) -> String {
        let title: OrderStatus = {
            switch status {
            case .claimed:
                OrderStatus.enRouteToPickup
            case .enRouteToPickup:
                OrderStatus.atPickup
            case .atPickup:
                OrderStatus.atDropoff
            case .atDropoff:
                OrderStatus.delivered
            case .delivered:
                OrderStatus.delivered
            default:
                OrderStatus.enRouteToPickup
            }
        }()
        return humanizeCamelCase(title.rawValue)
    }
}

// #Preview {
//    ModelPreview { order in
//        DriverStopCard(order: order)
//    }.environmentObject(AppStateModel())
// }
