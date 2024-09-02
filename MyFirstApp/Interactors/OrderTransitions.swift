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
            updateOrderStatus(with: newState.currentStatus)
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

    private func updateOrderStatus(with newStatus: OrderStatus) {
        state.order.status = newStatus.rawValue
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
        return true // Default implementation, can be overridden by subclasses
    }

    var currentStatus: OrderStatus {
        return order.comparableStatus
    }

    func nextState(for order: Order) -> IOrderTransitionState {
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
}

class CanceledConcreteState: OrderTransitionsBaseState {
    override func canTransitionTo(state: IOrderTransitionState) -> Bool {
        return false
    }

    override func nextState(for order: Order) -> IOrderTransitionState {
        return CanceledConcreteState(order) // do nothing
    }
}
