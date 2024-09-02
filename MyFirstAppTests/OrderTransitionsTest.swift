//
//  OrderTransitionsTest.swift
//  MyFirstAppTests
//
//  Created by Joshua Wilson on 8/30/24.
//

@testable import MyFirstApp
import XCTest

//
// class OrderTransitionsTests: XCTestCase {
//    func testValidTransitions() {
//        let customer = Customer(name: "Jake")
//        let order = createOrders(customer: customer)
//
//        let context = OrderContext(state: UnassignedConcreteState(order))
//
//        // Transition from Unassigned to Claimed
//        let claimedState = ClaimedConcreteState(order)
//        context.transitionTo(state: claimedState)
//        XCTAssertTrue(order.comparableStatus == .claimed, "Order status should be 'claimed'")
//
//        // Transition from Claimed to EnrouteToPickup
//        let enrouteState = EnrouteToPickupConcreteState(order)
//        context.transitionTo(state: enrouteState)
//        XCTAssertTrue(order.comparableStatus == .enRouteToPickup, "Order status should be 'enRouteToPickup'")
//
//        // Transition from EnrouteToPickup to AtPickup
//        let atPickupState = AtPickupConcreteState(order)
//        context.transitionTo(state: atPickupState)
//        XCTAssertTrue(order.comparableStatus == .atPickup, "Order status should be 'atPickup'")
//    }

//    func testInvalidTransitions() {
//        let customer = Customer(name: "Jake")
//        let order = createOrders(customer: customer)
//        let context = OrderContext(state: UnassignedConcreteState(order))
//
//        // Attempt invalid transition from Unassigned to AtPickup
//        let atPickupState = AtPickup(order)
//        context.transitionTo(state: atPickupState)
//        XCTAssertFalse(order.status == .atPickup, "Order status should not be 'atPickup'")
//
//        // Transition to Claimed first
//        let claimedState = ClaimedConcreteState(order)
//        context.transitionTo(state: claimedState)
//        XCTAssertTrue(order.status == .claimed, "Order status should be 'claimed'")
//
//        // Attempt invalid transition from Claimed to AtPickup
//        context.transitionTo(state: atPickupState)
//        XCTAssertFalse(order.status == .atPickup, "Order status should not be 'atPickup'")
//    }
//
//    func testStatusUpdates() {
//        let order = Order()
//        let context = OrderContext(state: UnassignedConcreteState(order))
//
//        // Transition from Unassigned to Claimed
//        let claimedState = ClaimedConcreteState(order)
//        context.transitionTo(state: claimedState)
//        XCTAssertTrue(order.status == .claimed, "Order status should be 'claimed'")
//
//        // Transition from Claimed to EnrouteToPickup
//        let enrouteState = EnrouteToPickupConcreteState(order)
//        context.transitionTo(state: enrouteState)
//        XCTAssertTrue(order.status == .enRouteToPickup, "Order status should be 'enRouteToPickup'")
//
//        // Transition from EnrouteToPickup to AtPickup
//        let atPickupState = AtPickup(order)
//        context.transitionTo(state: atPickupState)
//        XCTAssertTrue(order.status == .atPickup, "Order status should be 'atPickup'")
//    }
// }
