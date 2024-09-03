//
//  OrderTransitions.swift
//  MyFirstApp
//
//  Created by Joshua Wilson on 8/30/24.
//

import Foundation

struct TransitionResult {
    var result: Result
    var message: String?

    init(_ result: Result, message: String? = nil) {
        self.result = result
        self.message = message
    }
}

protocol IOrderTransitionState {
    var order: Order { get set }
    var currentStatus: OrderStatus { get }
    func update(context: OrderContext)
    func canTransitionTo(state: IOrderTransitionState) -> Bool
    func nextState(for order: Order) -> IOrderTransitionState
    func updateOrderStatus() -> Void
}

class OrderContext {
    private var state: IOrderTransitionState

    init(state: IOrderTransitionState) {
        self.state = state
        //  transitionTo(state: state)
    }

    // Other objects must be able to switch the orders
    // current state. //marked as private, outside should just use next and previousState(when I build that one)
    private func transitionTo(newState: IOrderTransitionState) -> TransitionResult {
        if state.canTransitionTo(state: newState) {
            state = newState
            state.updateOrderStatus()
            state.update(context: self)
            return TransitionResult(.success)
        }
        print("Invalid transition from \(type(of: state)) to \(type(of: state))")
        return TransitionResult(.failure, message: "Invalid transition from \(type(of: state)) to \(type(of: state))")
    }

    // writing test, takes in the currentState
    func transitionToNextState() -> TransitionResult {
        return transitionTo(newState: state.nextState(for: state.order))
    }

    func transitionToCancel() -> TransitionResult {
        return transitionTo(newState: CanceledConcreteState(state.order))
    }

    func transitionToClaimed() -> TransitionResult {
        return transitionTo(newState: ClaimedConcreteState(state.order))
    }

    func transisitionToUnassigned() -> TransitionResult {
        return transitionTo(newState: UnassignedConcreteState(state.order))
    }
}

class OrderTransitionsBaseState: IOrderTransitionState {
    var order: Order
    private(set) weak var context: OrderContext?

    init(_ order: Order, context: OrderContext? = nil) {
        self.order = order
        self.context = context
        // self.currentState = currentState(order)
    }

    func update(context: OrderContext) {
        self.context = context
    }

    func canTransitionTo(state: IOrderTransitionState) -> Bool {
        logBaseWarning("canTransitionTo")
        return true // Default implementation, can be overridden by subclasses
    }

    var currentStatus: OrderStatus {
        return order.comparableStatus
    }

    func updateOrderStatus() {
        logBaseWarning("updateOrderStatus")
        return order.status = currentStatus.rawValue // do nothing
    }

    func nextState(for order: Order) -> IOrderTransitionState {
        logBaseWarning("nextState")
        let nextState: IOrderTransitionState = { switch currentStatus {
        case .unassigned:
            ClaimedConcreteState(order)
        case .canceled:
            CanceledConcreteState(order)
        case .claimed:
            EnrouteToPickupConcreteState(order)
        case .enRouteToPickup:
            AtPickupConcreteState(order)
        case .atPickup:
            EnRouteToDropoffConcreteState(order)
        case .enRouteToDropoff:
            AtDropoffConcreteState(order)
        case .atDropoff:
            DeliveredConcreteState(order)
        case .delivered:
            DeliveredConcreteState(order)
        }
        }()
        return nextState
    }

    func logBaseWarning(_ method: String) {
        Logger.log(.warning, "Implemented base behavior \(self), #\(method)")
    }
}

class UnassignedConcreteState: OrderTransitionsBaseState { // extends
    override var currentStatus: OrderStatus {
        return OrderStatus.unassigned
    }

    override func canTransitionTo(state: IOrderTransitionState) -> Bool {
        return state is DeliveredConcreteState ? false : true // or should I only allow to go to claim?
    }

    override func nextState(for order: Order) -> IOrderTransitionState {
        return ClaimedConcreteState(order)
    }

    override func updateOrderStatus() {
        order.status = currentStatus.rawValue
    }
}

class ClaimedConcreteState: OrderTransitionsBaseState {
    override var currentStatus: OrderStatus {
        return OrderStatus.claimed
    }

    override func canTransitionTo(state: IOrderTransitionState) -> Bool {
        return state is EnrouteToPickupConcreteState || state is CanceledConcreteState || state is UnassignedConcreteState
    }

    override func nextState(for order: Order) -> IOrderTransitionState {
        return EnrouteToPickupConcreteState(order)
    }

    override func updateOrderStatus() {
        order.status = currentStatus.rawValue
    }
}

class EnrouteToPickupConcreteState: OrderTransitionsBaseState {
    override var currentStatus: OrderStatus {
        return OrderStatus.enRouteToPickup
    }

    override func canTransitionTo(state: IOrderTransitionState) -> Bool {
        return state is AtPickupConcreteState || state is CanceledConcreteState || state is UnassignedConcreteState
    }

    override func nextState(for order: Order) -> IOrderTransitionState {
        return AtPickupConcreteState(order)
    }

    override func updateOrderStatus() {
        order.status = currentStatus.rawValue
    }
}

class AtPickupConcreteState: OrderTransitionsBaseState {
    override var currentStatus: OrderStatus {
        return OrderStatus.atPickup
    }

    override func canTransitionTo(state: IOrderTransitionState) -> Bool {
        return state is EnRouteToDropoffConcreteState || state is CanceledConcreteState || state is UnassignedConcreteState
    }

    override func nextState(for order: Order) -> IOrderTransitionState {
        return EnRouteToDropoffConcreteState(order)
    }

    override func updateOrderStatus() {
        order.status = currentStatus.rawValue
    }
}

class EnRouteToDropoffConcreteState: OrderTransitionsBaseState {
    override var currentStatus: OrderStatus {
        return OrderStatus.enRouteToDropoff
    }

    override func canTransitionTo(state: IOrderTransitionState) -> Bool {
        return state is AtDropoffConcreteState || state is CanceledConcreteState || state is UnassignedConcreteState
    }

    override func nextState(for order: Order) -> IOrderTransitionState {
        return AtDropoffConcreteState(order)
    }

    override func updateOrderStatus() {
        order.status = currentStatus.rawValue
        order.pickup.deliveredAt = .now
    }
}

class AtDropoffConcreteState: OrderTransitionsBaseState {
    override var currentStatus: OrderStatus {
        return OrderStatus.atDropoff
    }

    override func canTransitionTo(state: IOrderTransitionState) -> Bool {
        return state is DeliveredConcreteState || state is UnassignedConcreteState
    }

    override func nextState(for order: Order) -> IOrderTransitionState {
        return DeliveredConcreteState(order)
    }

    override func updateOrderStatus() {
        order.status = currentStatus.rawValue
    }
}

class DeliveredConcreteState: OrderTransitionsBaseState {
    override var currentStatus: OrderStatus {
        return OrderStatus.delivered
    }

    override func canTransitionTo(state: IOrderTransitionState) -> Bool {
        return false
    }

    override func nextState(for order: Order) -> IOrderTransitionState {
        return DeliveredConcreteState(order) // do nothing
    }

    override func updateOrderStatus() {
        order.status = currentStatus.rawValue
        order.dropoff.deliveredAt = .now
    }
}

class CanceledConcreteState: OrderTransitionsBaseState {
    override var currentStatus: OrderStatus {
        return OrderStatus.canceled
    }

    override func canTransitionTo(state: IOrderTransitionState) -> Bool {
        return false
    }

    override func nextState(for order: Order) -> IOrderTransitionState {
        return CanceledConcreteState(order) // do nothing
    }

    override func updateOrderStatus() {
        order.status = currentStatus.rawValue
    }
}
