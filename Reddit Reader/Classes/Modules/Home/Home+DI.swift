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
                $0.register(HomeViewModel.self) { _ in
                    HomeViewModel(apiPosts: API.posts())
                }
                $0.register(HomeViewController.self) { r in
                    let viewModel = r.resolve(HomeViewModel.self)!
                    return HomeViewController(viewModel: viewModel)
                }
            }
        }
    }
}
