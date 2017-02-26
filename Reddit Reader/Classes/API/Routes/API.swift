//
//  API.swift
//  Reddit Reader
//
//  Created by Jonathan Pacheco on 2/24/17.
//  Copyright © 2017 Etermax. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import ObjectMapper

struct API {
    
    static func posts() -> APIPosts {
        return APIPosts()
    }
}

struct Services {
    
    private init() {}
    
    /// Reddit Services
    ///
    /// - top: The top post in reddit
    enum Reddit {
        case top
    }
}

// Default values for `TargetType`
extension TargetType {
    
    /// The HTTP method used in the request.
    var method: Moya.Method { return .get }
    
    /// The parameters to be incoded in the request.
    var parameters: [String: Any]? { return [:] }
    
    /// The method used for parameter encoding.
    var parameterEncoding: ParameterEncoding { return JSONEncoding.default }
    
    /// Provides stub data for use in testing.
    var sampleData: Data { return Data() }
    
    /// The type of HTTP task to be performed.
    var task: Task { return Task.request }
    
    /// Whether or not to perform Alamofire validation. Defaults to `false`.
    var validate: Bool { return false }
}


/// Posibles errors
///
/// - map: Ocurre when cannot map json to object
enum ServiceErrors: Swift.Error {
    case map(String)
}
