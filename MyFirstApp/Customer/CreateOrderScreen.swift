//
//  CreateOrder.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 5/20/24.
//

import SwiftData
import SwiftUI

struct SheetController {
    var isPresented: Bool
    var type: String // "pickup" | "dropoff"
}

// WHere I left off
//line 82
// concat the addresses for display.
// now work on map for drivers with routes

struct CreateOrderScreen: View {
    @Query private var orderModelOrders: [Order]
    @Environment(\.modelContext) private var context // how to CRUD state
    @EnvironmentObject var appState: AppStateModel

    let inputHeight = 40.0
    @State private var currentAddresses: [LocationResult] = []
    @State var sheetController = SheetController(isPresented: false, type: "pickup")
    @State private var orderNumber: String = ""
    @State private var pickupLocation: LocationResult = .init(title: "", subtitle: "")
    @State private var pickupPhoneNumber: String = ""
    @State private var pickupContactName: String = ""
    @State private var pickupCompanyOrOrg: String = ""

    @State private var dropoffLocation: LocationResult = .init(title: "", subtitle: "")
    @State private var dropoffPhoneNumber: String = ""
    @State private var dropoffContactName: String = ""
    @State private var dropoffCompanyOrOrg: String = ""
    @State private var dropoffNotes: String = ""

    var body: some View {
        VStack {
            Text("Create An Order").bold().font(.title).multilineTextAlignment(.center).padding().shadow(radius: 8)
            //  if let pickupLocationSelected = pickupLocation {
            MapView(addresses: $currentAddresses)
            // }

            Form { // forms should not be nested in scrollviews, they are already scrollviews
                Section(header: Text("Order Information").bold().font(.title2)) {
                    TextField("Order Number", text: $orderNumber).frame(height: inputHeight)
                }
                Section(header: Text("Pickup").bold().font(.title2)) {
                    TextField("Pickup Location", text: $pickupLocation.title).frame(height: inputHeight).onTapGesture {
                        sheetController.type = "pickup"
                        sheetController.isPresented = true
                    }
                    TextField("Phone number", text: $pickupPhoneNumber).frame(height: inputHeight)
                    TextField("Contact name", text: $pickupContactName).frame(height: inputHeight)
                    TextField("Company or Organization", text: $pickupCompanyOrOrg).frame(height: inputHeight)
                }
                Section(header: Text("Drop Off").bold().font(.title2)) {
                    TextField("Dropoff Location", text: $dropoffLocation.title).frame(height: inputHeight).onTapGesture {
                        sheetController.type = "dropoff"
                        sheetController.isPresented = true
                    }
                    TextField("Phone number", text: $dropoffPhoneNumber).frame(height: inputHeight)
                    TextField("Contact name", text: $dropoffContactName).frame(height: inputHeight)
                    TextField("Company or Organization", text: $dropoffCompanyOrOrg).frame(height: inputHeight)
                    TextField("Drop-off Notes", text: $dropoffNotes).frame(height: inputHeight * 4)
                }
                MyButton(title: "Create", onPress: create, backgroundColor: Color.green, image: "checkmark", frame: Frame(height: 40)).frame(maxWidth: .infinity)
                MyButton(title: "Random", onPress: prePopulate, backgroundColor: Color.blue, image: "checkmark", frame: Frame(height: 40)).frame(maxWidth: .infinity)
            }
        }.sheet(isPresented: $sheetController.isPresented) {
            AddressSelection(isPresented: $sheetController.isPresented, address: sheetController.type == "pickup" ? $pickupLocation : $dropoffLocation, currentAddresses: $currentAddresses)
        }
    }

    func create() {
        print(context)
        if let customer = appState.loggedInCustomer {
            // TODO: Move the pickup and dropp off data to their respective models, then will need to update UI, don;t think anything else needs to be updated
            let newOrder = Order(orderNumber: orderNumber, pickupLocation: pickupLocation.title + pickupLocation.subtitle, pickupPhoneNumber: pickupPhoneNumber, pickupContactName: pickupContactName, pickupCompanyOrOrg: pickupCompanyOrOrg, dropoffLocation: dropoffLocation.title + dropoffLocation.subtitle, dropoffPhoneNumber: dropoffPhoneNumber, dropoffContactName: dropoffContactName, dropoffCompanyOrOrg: dropoffCompanyOrOrg, pay: 100, customer: customer)

            let pickup = Pickup(order: order, address: pickupLocation.title, cityStateZip: pickupLocation.subtitle, locationId: pickupLocation.id, phoneNumber: pickupPhoneNumber, contactName: pickupContactName, company: pickupCompanyOrOrg)
            let dropoff = Dropoff(order: order, address: dropoffLocation.title, cityStateZip: dropoffLocation.subtitle, locationId: dropoffLocation.id, phoneNumber: dropoffPhoneNumber, contactName: dropoffContactName, company: dropoffCompanyOrOrg)

            context.insert(newOrder)
            context.insert(pickup)
            context.insert(dropoff)

            customer.handleOrderAction(action: CustomerOrderAction.place, order: newOrder)
            do {
                try customer.modelContext?.save()
                try context.save()
            } catch {
                print("Error creating order: \(error)")
            }
        } else {
            print("No customer logged in to create the order")
        }
    }

    func prePopulate() {
        orderNumber = "123"
        pickupLocation = LocationResult(id: UUID(), title: "1234 main st", subtitle: "Kansas City, MO 64127")
        pickupPhoneNumber = "281-330-8004"
        pickupContactName = "Mike Jones"
        pickupCompanyOrOrg = "Swishahouse"
        dropoffLocation = LocationResult(id: UUID(), title: "6789 broadway st", subtitle: "Kansas City, MO 64111")
        dropoffPhoneNumber = "904-490-7777"
        dropoffContactName = "Johnny"
        dropoffCompanyOrOrg = "Diamond Boys"
    }
}

#Preview {
    CreateOrderScreen().modelContainer(for: [Order.self, Customer.self], inMemory: true).environmentObject(AppStateModel()) // needs to be added to insert the modelContext, making it possible to CRUD state
    // https://developer.apple.com/tutorials/develop-in-swift/save-data
}
