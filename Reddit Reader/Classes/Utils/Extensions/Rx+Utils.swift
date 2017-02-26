//
//  Rx+Utils.swift
//  Reddit Reader
//
//  Created by Jonathan Pacheco on 2/24/17.
//  Copyright © 2017 Etermax. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Then

extension Observable: Then {}

extension NSObject {
    
    fileprivate struct AssociatedKeys {
        static var DisposeBagKey = "bnd_DisposeBagKey"
        static var AssociatedObservablesKey = "bnd_AssociatedObservablesKey"
    }
    
    // A dispose bag will will dispose upon object deinit.
    public var disposeBag: DisposeBag {
        if let disposeBag: AnyObject = objc_getAssociatedObject(self, &AssociatedKeys.DisposeBagKey) as AnyObject? {
            return disposeBag as! DisposeBag
        } else {
            let disposeBag = DisposeBag()
            objc_setAssociatedObject(self, &AssociatedKeys.DisposeBagKey, disposeBag, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return disposeBag
        }
    }
}

struct RxDisposableReusable {
    unowned private var disposeBag: DisposeBag
    private var disposables: [Disposable] = []
    
    init(_ disposeBag: DisposeBag) {
        self.disposeBag = disposeBag
    }
    
    mutating func dispose() {
        disposables.forEach {
            $0.dispose()
        }
        disposables.removeAll()
    }
    
    fileprivate mutating func add(disposable: Disposable) {
        disposables.append(disposable)
        disposable.addDisposableTo(disposeBag)
    }
}

func +=(lhs: inout RxDisposableReusable, rhs: Disposable) {
    lhs.add(disposable: rhs)
}
func +=(lhs: inout RxDisposableReusable!, rhs: Disposable) {
    lhs?.add(disposable: rhs)
}
func +=(lhs: inout RxDisposableReusable?, rhs: Disposable) {
    lhs?.add(disposable: rhs)
}
