//
//  Home+DI.swift
//  Reddit Reader
//
//  Created by Jonathan Pacheco on 2/21/17.
//  Copyright © 2017 Jonathan Pacheco. All rights reserved.
//

import Foundation
import Swinject

extension DI {
    
    struct Home: DependencyInjection {
        
        static func resolveDependency<Type>() -> Type? {
            return registerDependecies().resolve(Type.self)
        }
        
        private static func registerDependecies() -> Container {
            return Container {
                $0.register(HomeViewController.self) { _ in
                    HomeViewController()
                }
            }
        }
    }
}
