//
//  APIPosts.swift
//  Reddit Reader
//
//  Created by Jonathan Pacheco on 2/24/17.
//  Copyright © 2017 Innovappte. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Moya
import Moya_ObjectMapper

extension Services.Reddit: TargetType {
    
    var baseURL: URL {
        return URL(string: "https://www.reddit.com/")!
    }
    
    var path: String {
        switch self {
        case .top:
            return "top/.json"
        }
    }
}

struct APIPosts {
    
    private let provider = RxMoyaProvider<Services.Reddit>()
    
    /// Get tops reedit posts
    func top() -> Observable<RedditResponse> {
        return provider.request(.top)
            .mapObject(RedditResponse.self)
    }
}
