//
//  Errors.swift
//  Reddit Reader
//
//  Created by Jonathan Pacheco on 2/24/17.
//  Copyright © 2017 Etermax. All rights reserved.
//

import Foundation

//MARK: - DI

enum DependencyInjectionError: Error {
    case noRegisterDependency
}
