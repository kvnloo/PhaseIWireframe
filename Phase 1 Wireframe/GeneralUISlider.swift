//
//  GeneralUISlider.swift
//  Phase 1 Wireframe
//
//  Created by Kevin Rajan on 5/28/17.
//  Copyright © 2017 veeman961. All rights reserved.
//

import UIKit

@IBDesignable
class GeneralUISlider: UISlider {

    @IBInspectable var angle: Float? {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        if let angle = angle {
                self.transform = CGAffineTransform(rotationAngle: (CGFloat)(angle / 180 * Float.pi))
        }
        
    }

}
