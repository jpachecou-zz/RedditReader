//
//  SplashViewController.swift
//  Reddit Reader
//
//  Created by Jonathan Pacheco on 2/25/17.
//  Copyright © 2017 Etermax. All rights reserved.
//

import UIKit
import SnapKit

class SplashViewController: UIViewController {

    @IBOutlet private weak var backgroundColor: UIView!
    @IBOutlet private weak var imageContainer:  UIView!
    @IBOutlet private weak var titleLabel:      UILabel!
    @IBOutlet private weak var copyrightLabel:  UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func splashAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.imageContainer.snp.remakeConstraints { make in
                make.leading.trailing.top.equalTo(self.view)
                make.height.equalTo(self.view).multipliedBy(0.3)
            }
            UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
                self.titleLabel.alpha = 0
                self.copyrightLabel.alpha = 0
                self.backgroundColor.alpha = 0
            }) { _ in
                self.removeFromParentViewController()
                self.view.removeFromSuperview()
            }
        }
    }
}
