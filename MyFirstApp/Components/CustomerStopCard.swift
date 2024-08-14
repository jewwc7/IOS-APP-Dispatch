//
//  CustomerStopCard.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 8/14/24.
//

import SwiftUI
import SwiftData


let testOrderTwo = Order( orderNumber: "123", pickupLocation: "1234 main st", pickupPhoneNumber: "281-330-8004", pickupContactName: "Mike Jones", pickupCompanyOrOrg: "Swishahouse", dropoffLocation: "6789 broadway st", dropoffPhoneNumber: "904-490-7777", dropoffContactName: "Johnny", dropoffCompanyOrOrg: "Diamond Boys", pay: 100, customer: Customer(name: "John"))

struct CustomerStopCardData: View {
     var order:Order
    
    var body: some View {
   
        VStack(alignment: .leading) {
            VStack(){
                Text("Pickup info").font(.title2)
            }.padding(.vertical,2)
            VStack(alignment:.leading) {
                Text("Organization")
                Text(order.pickupCompanyOrOrg).bold()
            }.padding(.vertical, 2)
            
            VStack(alignment:.leading) {
                Text("Address")
                Text(order.pickupLocation ).bold()
            }.padding(.vertical, 2)
            HStack {
                VStack(alignment:.leading) {
                    
                    Text("Contact name")
                    Text(order.pickupContactName).bold()
                }
                VStack(alignment:.leading) {
                    Text("Phone")
                    Text(order.pickupPhoneNumber).bold()
                }
                
            }
          .padding(.vertical, 2)
           
            
            Divider()
            VStack(alignment: .leading) {
                VStack(){
                    Text("Dropoff info").font(.title2)
                }.padding(.vertical,2)
                VStack(alignment:.leading) {
                    Text("Organization")
                    Text(order.dropoffCompanyOrOrg).bold()
                }.padding(.vertical, 2)
                
                VStack(alignment:.leading) {
                    Text("Address")
                    Text(order.dropoffLocation ).bold()
                }.padding(.vertical, 2)
                HStack {
                    VStack(alignment:.leading) {
                        
                        Text("Contact name")
                        Text(order.dropoffContactName).bold()
                    }
                    VStack(alignment:.leading) {
                        Text("Phone")
                        Text(order.dropoffPhoneNumber).bold()
                    }
                    
                }
            }
            
            Spacer()
            

        }.padding().overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.blue, lineWidth: 2)
        )
    }
}



struct CustomerStopCard: View {
    @State private var isExpanded: Bool = false
    var order:Order
    
    var body: some View {
        let labelAndSytemImage =  getLabelAndSystemImage(order:order)
        
        VStack(alignment: .leading) {
            // Header
            HStack {
                VStack(alignment:.leading) {
                    Text("Pickup: \(order.pickupLocation)")
                        .font(.headline)
                    Text("Dropoff: \(order.dropoffLocation)")
                        .font(.headline)
//                        .padding()
                    MyChip(text: order.dueAtFormatted())
                    if let orderDriver = order.driver {
                        HStack {
                                      Image(systemName: "person").foregroundColor(.green)
                                      Text(orderDriver.name)
                        }.padding(.vertical, 6)
                    }else {
                        Label(labelAndSytemImage.text, systemImage: labelAndSytemImage.image).foregroundColor(.green)
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
                CustomerStopCardData(order: order).transition(.opacity) // Transition effect when expanding/collapsing
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
    
    func getLabelAndSystemImage(order:Order)-> LabelAndSystemImage{
        if(order.delivered()){
            return  LabelAndSystemImage(text: "Delivered", image: "checkmark")
        }
        if(order.inProgess()){
            return LabelAndSystemImage(text: humanizeCamelCase(order.status.rawValue), image: "car")
        }
        if(order.claimed()){
            return LabelAndSystemImage(text: "Claimed", image: "person.fill.checkmark")
            //car and status
        }
        else{
            return LabelAndSystemImage(text: "Unassigned", image: "magnifyingglass")
        }
        
    }
}



#Preview {
    CustomerStopCard(order:testOrderTwo).modelContainer(for: [Order.self, Customer.self], inMemory: true).environmentObject(AppStateModel()) //needs to be added to insert the modelContext, making it possible to CRUD state
    //https://developer.apple.com/tutorials/develop-in-swift/save-data
}
