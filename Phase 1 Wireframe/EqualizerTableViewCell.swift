//
//  EqualizerTableViewCell.swift
//  Phase 1 Wireframe
//
//  Created by Kevin Rajan on 5/29/17.
//  Copyright © 2017 veeman961. All rights reserved.
//

import UIKit
import VerticalSlider

class EqualizerTableViewCell: GeneralUITableViewCell {
    
    @IBOutlet weak var sliderStackView: UIStackView!
    @IBOutlet weak var labelStackView: UIStackView!
    
    var row: Int? {
        didSet {
            updateSelf()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        for label in labelStackView.subviews {
            (label as! GeneralUILabel).font = UIFont.EQUALIZER
        }
        for view in sliderStackView.subviews {
            let slider = view as! VerticalSlider
            slider.slider.addTarget(nil, action: #selector(EqualizerViewController.updateGains), for: .valueChanged)
        }
    }
    
    func updateSelf() {
        let labels =  labelStackView.subviews
        if row == 0 {
            // highs
            sliderStackView.tintColor = UIColor.RED
            (labels[0] as! GeneralUILabel).text = "1kHz"
            (labels[1] as! GeneralUILabel).text = "2kHz"
            (labels[2] as! GeneralUILabel).text = "3kHz"
            (labels[3] as! GeneralUILabel).text = "4kHz"
            (labels[4] as! GeneralUILabel).text = "5kHz"
            (labels[5] as! GeneralUILabel).text = "10kHz"
            (labels[6] as! GeneralUILabel).text = "16kHz"
            
        } else {
            // lows
            sliderStackView.tintColor = UIColor.BLUE
            (labels[0] as! GeneralUILabel).text = "8Hz"
            (labels[1] as! GeneralUILabel).text = "16Hz"
            (labels[2] as! GeneralUILabel).text = "32Hz"
            (labels[3] as! GeneralUILabel).text = "64Hz"
            (labels[4] as! GeneralUILabel).text = "128Hz"
            (labels[5] as! GeneralUILabel).text = "256Hz"
            (labels[6] as! GeneralUILabel).text = "512Hz"
        }
    }
}
