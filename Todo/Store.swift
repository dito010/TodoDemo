//
//  Store.swift
//  Todo
//
//  Created by 尹久盼 on 06/09/2017.
//  Copyright © 2017 尹久盼. All rights reserved.
//

import Foundation

protocol ActionType {}
protocol CommandType {}
protocol StateType {}

class Store<ActionType, CommandType, StateType> {
    let reducer: (_ state: StateType, _ action: ActionType) -> (StateType, CommandType?)
    var subscriber: ((_ state: StateType, _ previousState: StateType?, _ command: CommandType?) -> Void)?
    var state: StateType
    
    init(reducer: @escaping (StateType, ActionType) -> (StateType, CommandType?), initialState: StateType) {
        self.reducer = reducer
        self.state = initialState
    }
    
    func subscriber(_ handler: @escaping (StateType, StateType?, CommandType?) -> Void) {
        self.subscriber = handler
    }
    
    func unsubscriber() {
        self.subscriber = nil
    }
    
    func dispatch(_ action: ActionType) {
        let previouState = state
        let (nextState, command) = reducer(previouState, action)
        state = nextState
        subscriber?(nextState, previouState, command)
    }
}
