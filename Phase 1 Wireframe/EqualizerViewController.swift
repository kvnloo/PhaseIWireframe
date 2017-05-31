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
class EqualizerViewController: GeneralUIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: IBOutlets
    
    /// This button allows the user to toggle between `Record` and `Stop` mode if in real time, otherwise it will allow toggling between `Play` and `Pause` mode.
    @IBOutlet weak var mainButton: UIButton!
    /// The `GeneralUITableView` that contains all of the bands for the `AVAudioUnitEQ`.
    @IBOutlet weak var tableView: GeneralUITableView!
    
    // MARK: Global Variables
    
    /// A flag used to represent if in realTime or if audio clip was recorded on the previous `GeneralUIViewConroller`.
    var realTime: Bool!
    /// If in `realTime`, this flag determines if the class is in record mode or stop mode. If not in realTime, this flag determines if the class is in play mode or pause mode.
    var state: Bool = true
    
    // MARK: Lifecycle
    
    /// Set's the `mainButton` imageView based on `realTime`.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Audio.sharedInstance.recordedAudio == nil {
            self.mainButton
                .setImage(#imageLiteral(resourceName: "record-button"), for: .normal)
        }
        APIManager.sharedInstance.loadData()
        if let user = APIManager.sharedInstance.user, let data = user.data {
            
            let split = data.split()
            let left = split.left
            let right = split.right
            for i in 0...(left.count - 1) {
                Audio.sharedInstance.leftEqualizer.bands[i].gain = left[i]
            }
            for i in 0...(right.count - 1) {
                Audio.sharedInstance.rightEqualizer.bands[i].gain = right[i]
            }
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
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(self.finishedPlayingClip), name: Audio.sharedInstance.notificationName, object: nil)
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
    
    // MARK: - TableView Setup
    
    /// Returns the number of sections in `tableView`.
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    /// Returns the height for row at `indexPath` in `tableView`.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2 {
            return 100
        }
        return 264
    }
    
    /// Returns the number of rows given the `section` in `tableView`.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else {
            return 3
        }
    }
    
    /// Returns the title for header given the `section` in `tableView`.
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Channel 0"
        default:
            return "Channel 1"
        }
    }
    
    /// Determines which cell to return based on the `indexPath` in `tableView`.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 2 {
            return tableView.dequeueReusableCell(withIdentifier: "EmptyCell") as! GeneralUITableViewCell
        } else {
            let cell: EqualizerTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SliderTableViewCell") as! EqualizerTableViewCell
            cell.section = indexPath.section
            cell.row = indexPath.row
            return cell
        }
    }
    
    /// This function is called as a callback function in the case that the number of channels requested from the tapped input is less than 2.
    func failedToGetDesiredNumberOfChannels() {
        // TODO: Notify User that only 1 channel is available
        var cell = tableView.cellForRow(at: IndexPath(row: 0, section: 1))
        cell?.isUserInteractionEnabled = false
        cell = tableView.cellForRow(at: IndexPath(row: 1, section: 1))
        cell?.isUserInteractionEnabled = false

    }
    
    /// This function is called every time a `VerticalSlider` changes. It updates the actual gain values within each equalizer.
    func updateGains() {
        let leftBands = Audio.sharedInstance.leftEqualizer.bands
        let rightBands = Audio.sharedInstance.rightEqualizer.bands
        
        if let cell1 = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? EqualizerTableViewCell {
            for i in 0...6 {
                leftBands[i + 7].gain = (cell1.sliderStackView.subviews[i] as! VerticalSlider).value
            }
        }
        if let cell2 = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? EqualizerTableViewCell {
            for i in 0...6 {
                leftBands[i].gain = (cell2.sliderStackView.subviews[i] as! VerticalSlider).value
            }
        }
        if let cell3 = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? EqualizerTableViewCell {
            for i in 0...6 {
                rightBands[i + 7].gain = (cell3.sliderStackView.subviews[i] as! VerticalSlider).value
            }
        }
        if let cell4 = tableView.cellForRow(at: IndexPath(row: 1, section: 1)) as? EqualizerTableViewCell {
            for i in 0...6 {
                rightBands[i].gain = (cell4.sliderStackView.subviews[i] as! VerticalSlider).value
            }
        }
        
    }
    
    /// This is a callback function to update UIElements after the clip finishes playing.
    func finishedPlayingClip() {
        print("notification received")
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
