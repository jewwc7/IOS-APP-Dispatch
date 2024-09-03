//
//  OrderTransitionsTest.swift
//  MyFirstAppTests
//
//  Created by Joshua Wilson on 8/30/24.
//

@testable import MyFirstApp
import XCTest

class OrderTransitionsTests: XCTestCase {
    var order: Order!
    var context: OrderContext!

    override func setUp() {
        super.setUp()
        let customer = Customer(name: "Jack")
        order = createOrders(customer: customer)
        context = OrderContext(state: UnassignedConcreteState(order))
    }

    override func tearDown() {
        order = nil
        context = nil
        super.tearDown()
    }

    func testTransitionToClaimed() {
        let result = context.transitionToClaimed()
        // test passes, but how can I add a byebug/breakpoint here and evaluate the order.
        XCTAssertEqual(result.result, .success)
        XCTAssertTrue(order.comparableStatus == .claimed)
    }

//    func testTransitionToEnrouteToPickup() {
//        context.transitionToClaimed()
//        let result = context.transitionToNextState()
//        XCTAssertEqual(result.result, .success)
//        XCTAssertTrue(context.state is EnrouteToPickupConcreteState)
//    }
//
//    func testTransitionToAtPickup() {
//        context.transitionToClaimed()
//        context.transitionToNextState()
//        let result = context.transitionToNextState()
//        XCTAssertEqual(result.result, .success)
//        XCTAssertTrue(context.state is AtPickupConcreteState)
//    }
//
//    func testTransitionToEnRouteToDropoff() {
//        context.transitionToClaimed()
//        context.transitionToNextState()
//        context.transitionToNextState()
//        let result = context.transitionToNextState()
//        XCTAssertEqual(result.result, .success)
//        XCTAssertTrue(context.state is EnRouteToDropoffConcreteState)
//    }
//
//    func testTransitionToAtDropoff() {
//        context.transitionToClaimed()
//        context.transitionToNextState()
//        context.transitionToNextState()
//        context.transitionToNextState()
//        let result = context.transitionToNextState()
//        XCTAssertEqual(result.result, .success)
//        XCTAssertTrue(context.state is AtDropoffConcreteState)
//    }
//
//    func testTransitionToDelivered() {
//        context.transitionToClaimed()
//        context.transitionToNextState()
//        context.transitionToNextState()
//        context.transitionToNextState()
//        context.transitionToNextState()
//        let result = context.transitionToNextState()
//        XCTAssertEqual(result.result, .success)
//        XCTAssertTrue(context.state is DeliveredConcreteState)
//    }
//
//    func testTransitionToCanceled() {
//        let result = context.transitionToCancel()
//        XCTAssertEqual(result.result, .success)
//        XCTAssertTrue(context.state is CanceledConcreteState)
//    }
//
//    func testInvalidTransitionFromDelivered() {
//        context.transitionToClaimed()
//        context.transitionToNextState()
//        context.transitionToNextState()
//        context.transitionToNextState()
//        context.transitionToNextState()
//        context.transitionToNextState()
//        let result = context.transitionToNextState()
//        XCTAssertEqual(result.result, .failure)
//        XCTAssertTrue(context.state is DeliveredConcreteState)
//    }
}
