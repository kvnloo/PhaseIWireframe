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

class EqualizerViewController: GeneralUIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var playButton: UIButton!
    
    // MARK: Global Variables
    var recordedAudio: RecordedAudioObject!
    var audioEngine: AVAudioEngine = AVAudioEngine()
    var equalizer: AVAudioUnitEQ!
    var audioPlayerNode: AVAudioPlayerNode = AVAudioPlayerNode()
    var audioFile: AVAudioFile!
    var state: Bool = true
    var changeAudioUnitTime = AVAudioUnitTimePitch()
    
    /// 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        if (recordedAudio == nil) {
            // TODO: Real time mic to speaker
//            playButton.isHidden = true
//        }
        
    }
    /// Check if user recorded clip or if they want to use real-time recording. If a clip was recorded, `setupAudioPlayer` and `setupAudioEngine` are called consequently.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setup()
//        if (recordedAudio == nil) {
            // TODO: Real time mic to speaker
//        } else {
//            setup()
//        }
        
    }
    
    /// This function creates an `AVAudioEngine` stored in `audioEngine`. It next creates an `AVAudioPlayerNode` and attaches it to `audioEngine`. Finally `equalizer` is initialized to `AVAudioUnitEQ` with 14 bands.
    func setup() {
        equalizer = AVAudioUnitEQ(numberOfBands: 5)
        audioEngine.attach(audioPlayerNode)
        audioEngine.attach(equalizer)
        
        // audioEngine.attach(changeAudioUnitTime)
        
        
        // TODO: find band values and attach the equalizer to the audioEngine
        
        let bands = equalizer.bands
//        let freqs = [ 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 3072, 4096, 5120, 10240, 16384 ]
        let freqs = [60, 230, 910, 4000, 14000]
        
        audioEngine.connect(audioPlayerNode, to: equalizer, format: nil)
        audioEngine.connect(equalizer, to: audioEngine.outputNode, format: nil)
        
        // audioEngine.connect(audioPlayerNode, to: changeAudioUnitTime, format: nil)
        // audioEngine.connect(changeAudioUnitTime, to: audioEngine.outputNode, format: nil)
        // changeAudioUnitTime.pitch = 800
        
        for i in 0...(bands.count - 1) {
            bands[i].bypass = false
            bands[i].frequency = Float(freqs[i])
            bands[i].filterType = .parametric
            bands[i].bandwidth  = 5.0
        }
        
        bands[0].gain = -10.0
        bands[0].filterType = .lowShelf
        bands[1].gain = -10.0
        bands[1].filterType = .lowShelf
        bands[2].gain = -10.0
        bands[2].filterType = .lowShelf
        bands[3].gain = 10.0
        bands[3].filterType = .highShelf
        bands[4].gain = 10.0
        bands[4].filterType = .highShelf
        
        
        for i in 0...(bands.count - 1)  {
            print("frequency: ", equalizer.bands[i].frequency, " gain: ", equalizer.bands[i].gain)
        }
        
        do {
            if let filepath = Bundle.main.path(forResource: "song", ofType: "mp3") {
                let filepathURL = NSURL.fileURL(withPath: filepath)
                audioFile = try AVAudioFile(forReading: filepathURL)
                audioEngine.prepare()
                try audioEngine.start()
                audioPlayerNode.scheduleFile(audioFile, at: nil, completionHandler: nil)

            }
        } catch _ {}
        
        
        
    }
    
    @IBAction func toggleAudio(_ sender: UIButton) {
        if state {
            audioPlayerNode.play()
            playButton.setImage(#imageLiteral(resourceName: "pause-button"), for: .normal)
            state = false
        } else {
            audioPlayerNode.pause()
            playButton.setImage(#imageLiteral(resourceName: "play-button"), for: .normal)
            state = true
        }
    }
    
}
