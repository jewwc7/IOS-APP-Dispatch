//
//  CreateOrder.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 5/20/24.
//

import SwiftData
import SwiftUI

struct CreateOrderScreen: View {
    @Query private var orderModelOrders: [Order]
    @Environment(\.modelContext) private var context // how to CRUD state
    @EnvironmentObject var appState: AppStateManager
    @Environment(\.presentationMode) var presentationMode // auto avaialble
    let errorManager = ErrorManager()

    let inputHeight = 40.0

    @State private var orderNumber: String = ""
    @State private var pickupLocation: LocationResult = .init(title: "", subtitle: "")
    @State private var pickupPhoneNumber: String = ""
    @State private var pickupContactName: String = ""
    @State private var pickupCompanyOrOrg: String = ""
    @State private var pickupDueAt: Date = .init()

    @State private var dropoffLocation: LocationResult = .init(title: "", subtitle: "")
    @State private var dropoffPhoneNumber: String = ""
    @State private var dropoffContactName: String = ""
    @State private var dropoffCompanyOrOrg: String = ""
    @State private var dropoffNotes: String = ""
    @State private var dropoffDueAt: Date = .init()

    @State private var isLoading: Bool = false
    var notificationManager = NotificationManager()

    var body: some View {
        VStack {
            // The updating UI error is caused by the map. Reporduce by prepopulating or entering address
            MapView(addresses: [pickupLocation, dropoffLocation])

            Form { // forms should not be nested in scrollviews, they are already scrollviews
                Section(header: Text("Order Information").bold().font(.title2)) {
                    TextField("Order Number", text: $orderNumber).frame(height: inputHeight)
                }
                Section(header: Text("Pickup").bold().font(.title2)) {
                    NavigationLink(destination: AddressSelection(address: $pickupLocation)) {
                        TextField("Pickup Location", text: concatenatedBinding($pickupLocation.title, $pickupLocation.subtitle)).frame(height: inputHeight)
                    }
                    TextField("Phone number", text: $pickupPhoneNumber).frame(height: inputHeight)
                    TextField("Contact name", text: $pickupContactName).frame(height: inputHeight)
                    TextField("Company or Organization", text: $pickupCompanyOrOrg).frame(height: inputHeight)
                    MyDatePicker(date: $pickupDueAt, title: "Pickup by")
                }
                Section(header: Text("Drop Off").bold().font(.title2)) {
                    NavigationLink(destination: AddressSelection(address: $dropoffLocation)) {
                        TextField("Dropoff Location", text: concatenatedBinding($dropoffLocation.title, $dropoffLocation.subtitle)).frame(height: inputHeight)
                    }
                    TextField("Phone number", text: $dropoffPhoneNumber).frame(height: inputHeight)
                    TextField("Contact name", text: $dropoffContactName).frame(height: inputHeight)
                    TextField("Company or Organization", text: $dropoffCompanyOrOrg).frame(height: inputHeight)
                    TextField("Drop-off Notes", text: $dropoffNotes).frame(height: inputHeight * 4)
                    MyDatePicker(date: $dropoffDueAt, title: "Dropoff by")
                }
            }
        }.toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: create) {
                    Image(systemName: "plus")
                    //  .foregroundColor(.green)
                    Text("Create")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: prePopulate) {
                    Text("Auto")
//                    Image(systemName: "trash")
//                        .foregroundColor(.red)
                }
            }
        }.navigationTitle("Place Order").toolbarRole(.editor)
    }

    // remove the uncessary data from orders
    func create() {
        isLoading = true
        if let customer = appState.loggedInCustomer {
            let pickup = Pickup(address: pickupLocation.title, cityStateZip: pickupLocation.subtitle, locationId: pickupLocation.id, phoneNumber: pickupPhoneNumber, contactName: pickupContactName, company: pickupCompanyOrOrg, dueAt: pickupDueAt)
            let dropoff = Dropoff(address: dropoffLocation.title, cityStateZip: dropoffLocation.subtitle, locationId: dropoffLocation.id, phoneNumber: dropoffPhoneNumber, contactName: dropoffContactName, company: dropoffCompanyOrOrg, dueAt: dropoffDueAt)

            let newOrder = Order(orderNumber: orderNumber, pay: randomPay(), customer: customer, pickup: pickup, dropoff: dropoff)
            context.insert(newOrder)
            // don't need to insert p/u and d/o because they are inserted when I insert the order

            do {
                try customer.handleOrderAction(action: CustomerOrderAction.place, order: newOrder)
                // try customer.modelContext?.save()
                try context.save()
                // used to simulat a 2second api request
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    orderCreatedMessage()
                    isLoading = false
                    presentationMode.wrappedValue.dismiss()
                }
            } catch let error as BaseError { // Swift checks if the error thrown conforms to the BaseError type or is a
                isLoading = false
                errorManager.handleError(error)
                Logger.log(.error, ["message": error.message, "type": error.type])
            } catch {
                isLoading = false
                Logger.log(.error, error.localizedDescription)
            }
        } else {
            isLoading = false
            print("No customer logged in to create the order")
        }
    }

    func prePopulate() {
        do {
            let prepopulatedData = try prepoluateOrder()

            if
                let streetAddress = prepopulatedData["streetAddress"],
                let cityStateZip = prepopulatedData["cityStateZip"],
                let contactName = prepopulatedData["contactName"],
                let organization = prepopulatedData["organization"],
                let dostreetAddress = prepopulatedData["dropoffStreetAddress"],
                let docityStateZip = prepopulatedData["dropoffCityStateZip"],
                let docontactName = prepopulatedData["dropoffContactName"],
                let doorganization = prepopulatedData["dropoffOrganization"]
            {
                orderNumber = String(Int.random(in: 1 ... 5000))
                pickupLocation = LocationResult(id: UUID(), title: streetAddress, subtitle: cityStateZip)
                pickupPhoneNumber = "281-330-8004"
                pickupContactName = contactName
                pickupCompanyOrOrg = organization
                dropoffLocation = LocationResult(id: UUID(), title: dostreetAddress, subtitle: docityStateZip)
                dropoffPhoneNumber = "904-490-7777"
                dropoffContactName = docontactName
                dropoffCompanyOrOrg = doorganization
            }

        } catch {
            Logger.log(.error, "prepopulate failed")
        }
    }

    func orderCreatedMessage() {
        notificationManager.displayNotification {
            Text("Order created!").foregroundColor(.white).font(.footnote).padding()
        }
    }

    private func concatenatedBinding(_ first: Binding<String>, _ second: Binding<String>) -> Binding<String> {
        return Binding<String>(
            get: {
                first.wrappedValue + " " + second.wrappedValue
            },
            set: { newValue in
                let components = newValue.split(separator: " ", maxSplits: 1, omittingEmptySubsequences: false)
                first.wrappedValue = components.first.map(String.init) ?? ""
                second.wrappedValue = components.dropFirst().first.map(String.init) ?? ""
            }
        )
    }
}

#Preview {
    CreateOrderScreen().modelContainer(for: [Order.self, Customer.self], inMemory: true).environmentObject(AppStateManager()) // needs to be added to insert the modelContext, making it possible to CRUD state
    // https://developer.apple.com/tutorials/develop-in-swift/save-data
}
