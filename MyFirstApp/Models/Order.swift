//
//  Order.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 5/20/24.
//

import SwiftData
import Foundation
import CoreData

//To resolve the issue, you need to ensure that OrderStatus conforms to PersistentModel. In SwiftData (and other similar frameworks like Core Data), enums that are used as properties of persistent models typically need to be marked as conforming to Codable so that they can be serialized and deserialized properly.
enum OrderStatus: String, Codable  { //
    case unassinged
    case canceled
    case claimed
    case enRouteToPickup
    case atPickup
    case atDropoff
    case delivered
}

@Model
class Order {
    // Properties
    var orderId: String
    var orderNumber: String?
    
    var pickupLocation: String
    var pickupPhoneNumber: String
    var pickupContactName: String
    var pickupCompanyOrOrg: String
    
    var dropoffLocation: String
    var dropoffPhoneNumber: String
    var dropoffContactName: String
    var dropoffCompanyOrOrg: String
    var pay: Int
    var due_at: Date
    var startedAt: Date? = nil
    var customer: Customer? = nil
    var driver: Driver? = nil
    var status:OrderStatus = OrderStatus.canceled
    let inProgressStatuses: Set<OrderStatus> = [OrderStatus.enRouteToPickup, OrderStatus.atPickup, OrderStatus.atDropoff]
    // Initializer
    init(
        orderNumber: String?,
        pickupLocation: String,
        pickupPhoneNumber: String,
        pickupContactName: String,
        pickupCompanyOrOrg: String,
        dropoffLocation: String,
        dropoffPhoneNumber: String,
        dropoffContactName: String,
        dropoffCompanyOrOrg: String,
        pay: Int,
        customer: Customer,
        status:OrderStatus = OrderStatus.unassinged,
        due_at: Date = Calendar.current.date(byAdding: .day, value: 7, to: Date()) ?? Date()) { //7 days from now or right now
            self.orderId = UUID().uuidString
            self.orderNumber = orderNumber
            self.pickupLocation = pickupLocation
            self.pickupPhoneNumber = pickupPhoneNumber
            self.pickupContactName = pickupContactName
            self.pickupCompanyOrOrg = pickupCompanyOrOrg
            self.dropoffLocation = dropoffLocation
            self.dropoffPhoneNumber = dropoffPhoneNumber
            self.dropoffContactName = dropoffContactName
            self.dropoffCompanyOrOrg = dropoffCompanyOrOrg
            self.pay = pay
            self.due_at = due_at//add time to this date
            self.startedAt = nil
            self.customer = customer
            self.driver = nil
            self.status = OrderStatus.unassinged
        }
    
    // Method
    func introduce() {
        print("Hello, my name is \(orderId) and I am being picked up from \(pickupLocation)  and am to be dropped off at \(dropoffLocation) for a cost of $\(pay).")
    }
    
    func late()->Bool{
        return self.due_at > Date()
    }
    
    func claim(driver:Driver)-> ResultWithMessage{
        let isClaimable = self.isClaimable()
        if isClaimable.result == .success {
            self.driver = driver
            self.status = OrderStatus.claimed
            return isClaimable
        }else {
            return isClaimable
        }
        
    }
    
    private func isClaimable()-> ResultWithMessage{
        if(self.driver != nil){
            return ResultWithMessage(result: .failure, message: "Driver already assigned")
        }
        if self.status == OrderStatus.canceled {
            return ResultWithMessage(result: .failure, message: "Order was canceled")
        }else {
            return ResultWithMessage(result: .success)
        }
    }
    
    func handleStatusTransition(){
        print("handleStatusTransition", order.status.rawValue)
        if(status == .delivered){
            return print("Order already delivered")
        }
        else if(canceled()){
           return print("Canceled order cant be delivered")
        }
        else if(unassigned()){
            self.status = .claimed
        }
        else if(claimed()){ //unassigned only here for testing purposes
            setEnRouteToPickup()
        }
        else if(self.status == .enRouteToPickup){
            setAtPickup()
        }else if(self.status == .atPickup){
            setAtDropOff()
        }
        else if(self.status == .atDropoff){
            setDelivered()
        }
        
        do {
            try modelContext?.save()
        } catch {
            print(error)
        }
    }
    
    func claimed()-> Bool{
        //commented out for testing
        return status == .claimed //&& driver != nil
       // return true
    }
    func unassigned()-> Bool{
        return status == .unassinged
    }
    
    func assigned()-> Bool{
        return order.status == .claimed && order.driver != nil
    }
    
    func started()->Bool {
        return startedAt != nil
    }
    func canceled()->Bool {
        return status == .canceled
    }
    func delivered()->Bool {
        return status == .delivered
    }
    func inProgess()-> Bool{
        return inProgressStatuses.contains(status)
    }
    private func setEnRouteToPickup(){
            if  false { // self.driver == nil
                print("order has no driver")
            }
            else {
                self.status = .enRouteToPickup
                self.startedAt = Date()
            }
        
    }
    private func setAtPickup(){
        print("setting @ pickup")
        if self.status != .enRouteToPickup  {
            print("please set enroute to pickup first")
        }else {
            self.status = .atPickup
        }
    }
    private func setAtDropOff(){
        if self.status != .atPickup  {
            print("please complete pickup first")
        }else {
            self.status = .atDropoff
        }
        
        
    }
    private func setDelivered(){
        
        if self.status != .atDropoff  {
            print("please setAtDropoff first")
        }else {
            self.status = .delivered
        }
        
        
    }
    
}


