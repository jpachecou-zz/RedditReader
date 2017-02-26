//
//  Splash+DI.swift
//  Reddit Reader
//
//  Created by Jonathan Pacheco on 2/25/17.
//  Copyright © 2017 Etermax. All rights reserved.
//

import Foundation
import Swinject

extension DI {
    
    struct Splash: DependencyInjection {
        
        static func resolveDependency<Type>() -> Type? {
            return registerDependency().resolve(Type.self)
        }
        
        private static func registerDependency() -> Container {
            return Container {
                $0.register(SplashViewController.self) { _ in
                    SplashViewController()
                }
            }
        }
    }
}
