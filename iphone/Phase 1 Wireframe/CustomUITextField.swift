//
//  CustomUITextField.swift
//  Phase 1 Wireframe
//
//  Created by Kevin Rajan on 5/24/17.
//  Copyright © 2017 veeman961. All rights reserved.
//

import UIKit

@IBDesignable
class CustomUITextField: GeneralUITextField {
    
    // MARK: - IBInspectable
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var leftPadding: CGFloat = 0
    @IBInspectable var imageWidth: CGFloat = 20
    @IBInspectable var color: UIColor = UIColor.WHITE {
        didSet {
            updateView()
        }
    }

    
    // MARK: - UITextField
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        return textRect
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        // Do any additional setup after awakening
        self.leftViewMode     = UITextFieldViewMode.always
    }

    
    // MARK: - Helper Functions
    func updateView() {
        if let image = leftImage {
            leftViewMode = UITextFieldViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: imageWidth, height: 20))
            imageView.image = image
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
            imageView.tintColor = color
            imageView.contentMode = .scaleAspectFit
            leftView = imageView
        } else {
            leftViewMode = UITextFieldViewMode.never
            leftView = nil
        }
    }
}
