//
//  UIColor+Utils.swift
//  Reddit Reader
//
//  Created by Jonathan Pacheco on 2/24/17.
//  Copyright © 2017 Etermax. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    
    static let main             = 0xF12909.color()
    static let darkBackground   = 0x172021.color()
    static let veryDarkGray     = 0x121315.color()
    
    
}

fileprivate extension Int {
    
    func color() -> UIColor {
        if self < 0 || self > 0xFFFFFF {
            return .black
        }
        return UIColor(
            red: CGFloat((self & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((self & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(self &  0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
