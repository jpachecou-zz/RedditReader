//
//  UIImageView+Utils.swift
//  Reddit Reader
//
//  Created by Jonathan Pacheco on 2/24/17.
//  Copyright © 2017 Etermax. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

enum UIImageViewErrors: Error {
    case invalidUrl
}

extension UIImageView {
    
    func load(urlString: String) -> Observable<Bool> {
        return Observable.create{ observer in
        
            guard let url = URL(string: urlString) else {
                observer.onError(UIImageViewErrors.invalidUrl)
                return Disposables.create()
            }
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                defer { observer.onCompleted() }
                if let error = error {
                    observer.onError(error)
                    return
                }
                if let data = data {
                    DispatchQueue.main.async {
                        self?.image = UIImage(data: data)
                    }
                    observer.onNext(true)
                    return
                }
                observer.onNext(false)
            }
            task.resume()
            return Disposables.create()
        }
    }
    
}
