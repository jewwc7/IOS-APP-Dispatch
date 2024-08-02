//
//  DriverOrderScreen.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 8/2/24.
//

import SwiftUI
import SwiftData

struct DriverOrderScreen: View {
    @Environment(\.modelContext) private var context //how to CRUD state
    @EnvironmentObject var appState: AppStateModel
    @State private var orderNumber: String = "123"
    @State private var pickupLocation: String = "1234 main st"
    @State private var pickupPhoneNumber: String = "1234 main st"
    @State private var pickupContactName: String = "Mike Jones"
    @State private var pickupCompanyOrOrg: String = "Swishahouse"
    
    @State private var dropoffLocation: String = "6789 broadway"
    @State private var dropoffPhoneNumber: String = "904-490-7777"
    @State private var dropoffContactName: String = "Johnny"
    @State private var dropoffCompanyOrOrg: String = "Diamond boys"
    @State private var dropoffNotes: String = "Be careful with my diamonds!"
    
    
    
    var body: some View {
        @State var order = Order( orderNumber: orderNumber, pickupLocation: pickupLocation, pickupPhoneNumber: pickupPhoneNumber, pickupContactName: pickupContactName, pickupCompanyOrOrg: pickupCompanyOrOrg, dropoffLocation: dropoffLocation, dropoffPhoneNumber: dropoffPhoneNumber, dropoffContactName: dropoffContactName, dropoffCompanyOrOrg:dropoffCompanyOrOrg, pay: 100, customer: Customer(name: "PlaceHolder customer"))
        
        ScrollView {
            if let loggedInDriver = appState.loggedInDriver {
                ForEach(loggedInDriver.orders, id: \.orderId){ order in
                    DriverOrderCard(order:order)
                }
            }
            
        }
    }
}

#Preview {
    DriverOrderScreen().modelContainer(for: [Order.self, Customer.self], inMemory: true).environmentObject(AppStateModel())
}



struct DriverOrderCard: View {
     var order:Order
 
    var body: some View {
        let dueAt = formatDate(date: order.due_at)
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
                VStack(alignment:.leading) {
                    Text("Contact name")
                    Text(order.dropoffContactName).bold()
                }.padding(.vertical, 2)
                VStack(alignment:.leading) {
                    Text("Phone#")
                    Text(order.dropoffPhoneNumber).bold()
                }.padding(.vertical, 2)
            }
            Text(dueAt)
            
            Spacer()
            
            MyButton(title:order.status.rawValue,onPress: handleOnPress, backgroundColor: Color.blue, image:"checkmark", frame: (Frame(height: 40, width: 140))).frame(maxWidth: .infinity)
        }.padding().overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.blue, lineWidth: 2)
        )
    }
    
    func formatDate(date:Date)->String{
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "HH:mm E, d MMM y"
        return formatter3.string(from: date)
    }
    
    func handleOnPress(){
        withAnimation(.easeInOut(duration: 0.5)) {
            order.handleStatusTransition()
        }
      
    }
}
