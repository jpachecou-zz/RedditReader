//
//  Operation.swift
//  Reddit Reader
//
//  Created by Jonathan Pacheco on 2/24/17.
//  Copyright © 2017 Etermax. All rights reserved.
//

import Then

enum OperationType {
    case main
    case background
}

private let backgroundQueue = OperationQueue().then {
    $0.name = "mm.background.operation.queue"
}

class Operation: Foundation.Operation {
    
    convenience override required init() {
        self.init(type: .background)
    }

    fileprivate(set) var type: OperationType
    
    init(type: OperationType = .background) {
        self.type = type
        super.init()
    }
    
    func execute() {
        switch type {
        case .main:
            OperationQueue.main.addOperation(self)
            break
        case .background:
            backgroundQueue.addOperation(self)
        }
    }
}
