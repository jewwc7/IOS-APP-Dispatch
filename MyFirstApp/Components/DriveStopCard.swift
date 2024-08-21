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
    var order: Order = createOrder()
    
    var body: some View {
        VStack(alignment: .leading) {
            // Header
            HStack {
                VStack(alignment: .leading) {
                    Text("Pickup: \(order.pickup?.fullAddress() ?? "")")
                        .font(.headline)
    
                    Text("Dropoff: \(order.dropoff?.fullAddress() ?? "")")
                        .font(.headline)
                        .padding(.top, 8)
                    HStack {
                        Text("Due:")
                        MyChip(text: order.dueAtFormatted())
                    }
                   
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
                DriveStopCardData(order: order).transition(.opacity) // Transition effect when expanding/collapsing
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
    var order: Order
    let pickup: Pickup
    let dropoff: Dropoff
    
    init(order: Order) {
        self.order = order
        self.pickup = order.pickup!
        self.dropoff = order.dropoff!
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack {
                Text("Pickup info").font(.title2)
            }.padding(.vertical, 2)
            VStack(alignment: .leading) {
                Text("Organization")
                Text(pickup.company).bold()
            }.padding(.vertical, 2)
            
            VStack(alignment: .leading) {
                Text("Address")
                Text(pickup.fullAddress()).bold()
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
           
            Divider()
            VStack(alignment: .leading) {
                VStack {
                    Text("Dropoff info").font(.title2)
                }.padding(.vertical, 2)
                VStack(alignment: .leading) {
                    Text("Organization")
                    Text(dropoff.company).bold()
                }.padding(.vertical, 2)
                
                VStack(alignment: .leading) {
                    Text("Address")
                    Text(dropoff.fullAddress()).bold()
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
            }
            
            Spacer()
            
            MyButton(title: driverRouteStatus(order.status), onPress: handleOnPress, backgroundColor: Color.blue, image: "checkmark", frame: Frame(height: 40, width: 140)).frame(maxWidth: .infinity).disabled(order.delivered())
        }.padding().overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.blue, lineWidth: 2)
        )
    }
    
    func handleOnPress() {
        withAnimation(.smooth) {
            order.handleStatusTransition()
            //  order.statusDidChange()
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

#Preview {
    ModelPreview { order in
        DriverStopCard(order: order)
    }.environmentObject(AppStateModel())
}
