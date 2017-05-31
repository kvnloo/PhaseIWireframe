//
//  EqualizerViewController.swift
//  Phase 1 Wireframe
//
//  Created by Kevin Rajan on 5/27/17.
//  Copyright © 2017 veeman961. All rights reserved.
//

import UIKit
import AVFoundation
import CoreAudio
import Foundation
import AudioToolbox
import VerticalSlider

/** This `GeneralUIViewController` controls the equalizer view. It allows the user to either stream real time audio from the microphone to the speaker after passing through a dual-channel equalizer. There are a total of 28 `VerticalSlider` objects that the user can control in order to change the gain at any given frequency.
 
    TODO: cleanup code.
 
 */
class EqualizerViewController: GeneralUIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var sliderStackView1: UIStackView!
    @IBOutlet weak var sliderStackView2: UIStackView!
    
    /// This button allows the user to toggle between `Record` and `Stop` mode if in real time, otherwise it will allow toggling between `Play` and `Pause` mode.
    @IBOutlet weak var mainButton: UIButton!
    
    // MARK: Global Variables
    
    /// A flag used to represent if in realTime or if audio clip was recorded on the previous `GeneralUIViewConroller`.
    var realTime: Bool!
    /// If in `realTime`, this flag determines if the class is in record mode or stop mode. If not in realTime, this flag determines if the class is in play mode or pause mode.
    var state: Bool = true
    var channel1: Bool!
    
    // MARK: Lifecycle
    
    /// Set's the `mainButton` imageView based on `realTime`.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Audio.sharedInstance.recordedAudio == nil {
            self.mainButton.setImage(#imageLiteral(resourceName: "record-button"), for: .normal)
        }

    }
    /// Check if user recorded clip or if they want to use real-time recording. Set the value for `realTime` based on if recordedAudio is nil. Once `realTime` is set, `setupEqualizer` is called.
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        Audio.sharedInstance.setupEqualizer(numberOfBands: 14)
        if Audio.sharedInstance.recordedAudio == nil {
            realTime = true
        } else {
            realTime = false
            Audio.sharedInstance.setupAudioEngine(realTime: realTime, handler: self.finishedPlayingClip)
        }
        if let user = APIManager.sharedInstance.user, let data = user.data {
            print("data: ", data)
            let split = data.split()
            let left = split.left
            let right = split.right
            for i in 0...(left.count - 1) {
                Audio.sharedInstance.leftEqualizer.bands[i].gain = left[i]
            }
            for i in 0...(right.count - 1) {
                Audio.sharedInstance.rightEqualizer.bands[i].gain = right[i]
            }
            if !channel1 {
                var sliders = (sliderStackView2.subviews + sliderStackView1.subviews)
                for i in 0...(sliders.count - 1) {
                    let slider = sliders[i] as! VerticalSlider
                    slider.slider.value = left[i]
                    
                }
            } else {
                var sliders = (sliderStackView2.subviews + sliderStackView1.subviews)
                for i in 0...(sliders.count - 1) {
                    let slider = sliders[i] as! VerticalSlider
                    slider.slider.value = right[i]
                    
                }
            }
        } else {
            print("data was null")
        }

        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.finishedPlayingClip), name: Audio.sharedInstance.notificationName, object: nil)
        for view in (sliderStackView1.subviews + sliderStackView2.subviews) {
            let slider = view as! VerticalSlider
            slider.slider.addTarget(nil, action: #selector(EqualizerViewController.updateGains), for: .valueChanged)
        }
    }
    
    /// Remove notification observers when view will disappear.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Stop listening notification
        NotificationCenter.default.removeObserver(self, name: Audio.sharedInstance.notificationName, object: nil)
    }
    
    /// Store data from the sliders.
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let user = APIManager.sharedInstance.user {
            let bands = Audio.sharedInstance.leftEqualizer.bands + Audio.sharedInstance.rightEqualizer.bands
            var gainData = [Float]()
            for band in bands {
                gainData.append(band.gain)
            }
            user.setData(data: gainData )
            APIManager.sharedInstance.saveData()
            
        }
    }
    
    /// This function is called as a callback function in the case that the number of channels requested from the tapped input is less than 2.
    func failedToGetDesiredNumberOfChannels() {
        // TODO: Notify User that only 1 channel is available
        APIManager.sharedInstance.vc = self.parent
//        var cell = tableView.cellForRow(at: IndexPath(row: 0, section: 1))
//        cell?.isUserInteractionEnabled = false
//        cell = tableView.cellForRow(at: IndexPath(row: 1, section: 1))
//        cell?.isUserInteractionEnabled = false

    }
    
    /// This function is called every time a `VerticalSlider` changes. It updates the actual gain values within each equalizer.
    func updateGains() {
        let leftBands = Audio.sharedInstance.leftEqualizer.bands
        let rightBands = Audio.sharedInstance.rightEqualizer.bands
        if !channel1 {
            for i in 0...6 {
                leftBands[i + 7].gain = (self.sliderStackView1.subviews[i] as! VerticalSlider).value
            }
            for i in 0...6 {
                leftBands[i].gain = (self.sliderStackView2.subviews[i] as! VerticalSlider).value
            }
        } else {
            for i in 0...6 {
                rightBands[i + 7].gain = (self.sliderStackView1.subviews[i] as! VerticalSlider).value
            }
            for i in 0...6 {
                rightBands[i].gain = (self.sliderStackView2.subviews[i] as! VerticalSlider).value
            }
        }
        
    }
    
    /// This is a callback function to update UIElements after the clip finishes playing.
    func finishedPlayingClip() {
        DispatchQueue.main.async {
            // Update UI
            self.mainButton.setImage(#imageLiteral(resourceName: "play-button"), for: .normal)
            self.state = true
        }
    }
    
    // MARK: - IBActions
    
    /// This IBAction is called by `mainButton`. Based on realTime and state, it manages setting the `imageView` for `mainButton`. As well as changing `state` for future toggles.
    @IBAction func toggleAudio(_ sender: UIButton) {
        if realTime {
            if state {
                Audio.sharedInstance.setupAudioEngine(realTime: realTime, handler: self.failedToGetDesiredNumberOfChannels)
                Audio.sharedInstance.startRecordingWithAudioEngine()
                mainButton.setImage(#imageLiteral(resourceName: "stop-button"), for: .normal)
                state = false
            } else {
                Audio.sharedInstance.stopRecordingWithAudioEngine()
                mainButton.setImage(#imageLiteral(resourceName: "record-button"), for: .normal)
                state = true
            }
        } else {
            if state {
                Audio.sharedInstance.playWithAudioPlayerNode()
                mainButton.setImage(#imageLiteral(resourceName: "pause-button"), for: .normal)
                state = false
            } else {
                Audio.sharedInstance.pauseWithAudioPlayerNode()
                mainButton.setImage(#imageLiteral(resourceName: "play-button"), for: .normal)
                state = true
            }
        }
    }
    
}
