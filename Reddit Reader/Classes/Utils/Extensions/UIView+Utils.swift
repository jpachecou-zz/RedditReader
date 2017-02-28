//
//  UIView+Utils.swift
//  Reddit Reader
//
//  Created by Jonathan Pacheco on 2/25/17.
//  Copyright © 2017 Etermax. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func topCornerRound(radius: CGFloat, border: Bool = false) {
        let shapeLayer = CAShapeLayer().then {
            $0.path = UIBezierPath(
                roundedRect: bounds,
                byRoundingCorners: [.topLeft, .topRight],
                cornerRadii: CGSize(width: radius, height: radius))
                .cgPath
        }
        if border {
            layer.borderColor = UIColor.main.cgColor
            layer.borderWidth = 1.0
        }
        layer.mask = shapeLayer
        layer.masksToBounds = true
    }
}
