//
//  OperationManager.swift
//  Reddit Reader
//
//  Created by Jonathan Pacheco on 2/24/17.
//  Copyright © 2017 Etermax. All rights reserved.
//

import Foundation


fileprivate class OperationManager {
    
    static fileprivate let shared = OperationManager()
    private var runOperations: [Operation] = []
    
    fileprivate func add(operation: Operation) {
        runOperations.append(operation)
    }
    
    fileprivate func remove(operation: Operation) {
        guard let index = runOperations.index(of: operation) else { return }
        runOperations.remove(at: index)
    }
}

extension Operation {
    
    func addForRetain() {
        OperationManager.shared.add(operation: self)
    }
    
    func removeForRetain() {
        OperationManager.shared.remove(operation: self)
    }
    
}
