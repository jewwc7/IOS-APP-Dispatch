//
//  DriverOrderCard.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 8/5/24.
//


import SwiftUI
import SwiftData


let testOrder = Order( orderNumber: "123", pickupLocation: "1234 main st", pickupPhoneNumber: "281-330-8004", pickupContactName: "Mike Jones", pickupCompanyOrOrg: "Swishahouse", dropoffLocation: "6789 broadway st", dropoffPhoneNumber: "904-490-7777", dropoffContactName: "Johnny", dropoffCompanyOrOrg: "Diamond Boys", pay: 100, customer: Customer(name: "John"))

struct DriveStopCardData: View {
     var order:Order
    
 
    var body: some View {
        let dueAt = order.dueAtFormatted()
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
            
            MyButton(title:order.status.rawValue,onPress: handleOnPress, backgroundColor: Color.blue, image:"checkmark", frame: (Frame(height: 40, width: 140))).frame(maxWidth: .infinity)
        }.padding().overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.blue, lineWidth: 2)
        )
    }
    
    func handleOnPress(){
        print("handleOnPress", order.status)
        withAnimation(.easeInOut(duration: 0.5)) {
            order.handleStatusTransition()
        }
      
    }
}



struct DriveStopCard: View {
    @State private var isExpanded: Bool = false
    var order:Order
    
    var body: some View {
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

#Preview {
    DriveStopCard(order:testOrder).modelContainer(for: [Order.self, Customer.self], inMemory: true).environmentObject(AppStateModel()) //needs to be added to insert the modelContext, making it possible to CRUD state
    //https://developer.apple.com/tutorials/develop-in-swift/save-data
}

//let testOrder = Order( orderNumber: "123", pickupLocation: "1234 main st", pickupPhoneNumber: "281-330-8004", pickupContactName: "Mike Jones", pickupCompanyOrOrg: "Swishahouse", dropoffLocation: "6789 broadway st", dropoffPhoneNumber: "904-490-7777", dropoffContactName: "Johnny", dropoffCompanyOrOrg: "Diamond Boys", pay: 100, customer: Customer(name: "John"))
//
//struct DriveStopCardData: View {
//     var order:Order
//
//    var body: some View {
//        let dueAt = order.dueAtFormatted()
//        VStack(alignment: .leading) {
//            VStack(){
//                Text("Pickup info").font(.title2)
//            }.padding(.vertical,2)
//            VStack(alignment:.leading) {
//                Text("Organization")
//                Text(order.pickupCompanyOrOrg).bold()
//            }.padding(.vertical, 2)
//            
//            VStack(alignment:.leading) {
//                Text("Address")
//                Text(order.pickupLocation ).bold()
//            }.padding(.vertical, 2)
//            HStack {
//                VStack(alignment:.leading) {
//                    
//                    Text("Contact name")
//                    Text(order.pickupContactName).bold()
//                }
//                VStack(alignment:.leading) {
//                    Text("Phone")
//                    Text(order.pickupPhoneNumber).bold()
//                }
//                
//            }
//          .padding(.vertical, 2)
//           
//            
//            Divider()
//            VStack(alignment: .leading) {
//                VStack(){
//                    Text("Dropoff info").font(.title2)
//                }.padding(.vertical,2)
//                VStack(alignment:.leading) {
//                    Text("Organization")
//                    Text(order.dropoffCompanyOrOrg).bold()
//                }.padding(.vertical, 2)
//                
//                VStack(alignment:.leading) {
//                    Text("Address")
//                    Text(order.dropoffLocation ).bold()
//                }.padding(.vertical, 2)
//                HStack {
//                    VStack(alignment:.leading) {
//                        
//                        Text("Contact name")
//                        Text(order.dropoffContactName).bold()
//                    }
//                    VStack(alignment:.leading) {
//                        Text("Phone")
//                        Text(order.dropoffPhoneNumber).bold()
//                    }
//                    
//                }
//            }
//            
//            Spacer()
//            
//            if shoulfDisplayDriver, let orderDriver = order.driver {
//                HStack {
//                    Image(systemName: "person")
//                    Text(orderDriver.name)
//                }
//            }else {
//                MyButton(title:order.status.rawValue,onPress: handleOnPress, backgroundColor: Color.blue, image:"checkmark", frame: (Frame(height: 40, width: 140))).frame(maxWidth: .infinity)
//            }
//     
//        }.padding().overlay(
//            RoundedRectangle(cornerRadius: 10)
//                .stroke(Color.blue, lineWidth: 2)
//        )
//    }
//    
//    func handleOnPress(){
//        print("handleOnPress", order.status)
//        withAnimation(.easeInOut(duration: 0.5)) {
//            order.handleStatusTransition()
//        }
//      
//    }
//}
//
//
//
//struct DriveStopCard: View {
//    @State private var isExpanded: Bool = false
//    var order:Order
//    
//    var body: some View {
//        VStack(alignment: .leading) {
//            // Header
//            HStack {
//                VStack(alignment:.leading) {
//                    Text("Pickup: \(order.pickupLocation)")
//                        .font(.headline)
//                    Text("Dropoff: \(order.dropoffLocation)")
//                        .font(.headline)
////                        .padding()
//                    MyChip(text: order.dueAtFormatted())
//                }.padding()
//            
//                
//                Spacer()
//                
//       
//                    
//                    Button(action: {
//                        withAnimation {
//                            isExpanded.toggle()
//                        }
//                    }) {
//                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
//                            .padding()
//                    }
//                
//            
//            }
//            .background(Color.gray.opacity(0.2))
//            .cornerRadius(10)
//            
//            // Content
//            if isExpanded {
//                DriveStopCardData(order: order).transition(.opacity) // Transition effect when expanding/collapsing
//                .background(Color.white)
//                .cornerRadius(10)
//                .shadow(radius: 5)
//            }
//        }
//        .padding()
////        .background(Color.white)
////        .cornerRadius(10)
////        .shadow(radius: 5)
//    }
//}
//
//#Preview {
//    DriveStopCard(order:testOrder).modelContainer(for: [Order.self, Customer.self], inMemory: true).environmentObject(AppStateModel()) //needs to be added to insert the modelContext, making it possible to CRUD state
//    //https://developer.apple.com/tutorials/develop-in-swift/save-data
//}
