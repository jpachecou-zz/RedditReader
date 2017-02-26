//
//  DI.swift
//  Reddit Reader
//
//  Created by Jonathan Pacheco on 2/24/17.
//  Copyright © 2017 Etermax. All rights reserved.
//

import Foundation

protocol DependencyInjection {
    
    static func resolveDependency<Type>() -> Type?
}

struct DI {
}
