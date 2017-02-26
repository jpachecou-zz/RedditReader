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
    
    func bottomGradientClear() {
//        layer.mask = CAGradientLayer().then {
//            $0.frame = bounds
//            $0.locations = [0.7, 1.0]
//            $0.startPoint = CGPoint(x: 0.5, y: 0)
//            $0.endPoint = CGPoint(x: 0.5, y: 1.0)
//            $0.colors = [UIColor.black, UIColor.clear]
//        }
    }
}
