//
//  MyCreatedOrders.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 5/21/24.
//

import SwiftUI
import SwiftData


let order = OrderModel( orderNumber: "123", pickupLocation: "1234 main st", pickupPhoneNumber: "281-330-8004", pickupContactName: "Mike Jones", pickupCompanyOrOrg: "Swishahouse", dropoffLocation: "6789 broadway st", dropoffPhoneNumber: "904-490-7777", dropoffContactName: "Johnny", dropoffCompanyOrOrg: "Diamond Boys", pay: 100)

struct MyCreatedOrders: View {
    @Query private var orders: [OrderModel]
    
   private var tempOrders:[OrderModel] = [order]

    var body: some View {
        NavigationView {
            List {
                ForEach(tempOrders, id: \.orderId){ order in
                    NavigationLink(destination: ViewOrder(order:order)) {
                        VStack{
                            HStack{
                                Text("Pickup Address:")
                                Spacer()
                                Text(order.pickupLocation)
                            }
                            HStack{
                                Text("Drop-Off Address:")
                                Spacer()
                                Text(order.dropoffLocation)
                            }
                        }
                    
                    }
                    
                }
            }
            
        }
    }
}

#Preview {
    MyCreatedOrders()
}


