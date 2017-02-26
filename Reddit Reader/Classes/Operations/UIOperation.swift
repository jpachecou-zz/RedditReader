//
//  UIOperation.swift
//  Reddit Reader
//
//  Created by Jonathan Pacheco on 2/24/17.
//  Copyright © 2017 Etermax. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class UIOperation: Operation {
    
    var isShouldDoPopToRoot = false
    var isNeedRemoveViewControllers = false
    weak var navigationController: UINavigationController?
    var disposable: RxDisposableReusable?
    var isPresent = false
    
    required init() {
        super.init(type: .main)
        navigationController = appDelegate.navigationController
    }
    
    override func main() {
        super.main()
        guard let vc = mainViewController() else { return }
        if isPresent {
            navigationController?.present(vc, animated: true, completion: nil)
        } else {
        if isShouldDoPopToRoot {
            _ = navigationController?.popToRootViewController(animated: false)
        }
        if isNeedRemoveViewControllers {
            navigationController?.viewControllers.removeAll()
        }
        navigationController?.pushViewController(vc, animated: !isNeedRemoveViewControllers)
        }
        disposable += vc.rx.deallocated
            .subscribe(onNext: { [unowned self] in
                self.disposable?.dispose()
                self.removeForRetain()
            })
        addForRetain()
    }
    
    func mainViewController() -> UIViewController? {
        return UIViewController()
    }
    
}
