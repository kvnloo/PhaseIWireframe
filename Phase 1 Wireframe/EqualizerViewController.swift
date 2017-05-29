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
    var audioPlayer: AVAudioPlayer!
    var audioEngine: AVAudioEngine!
    var audioUnit: AudioUnit!
    var equalizer: AVAudioUnitEQ!

    /// Check if user recorded clip or if they want to use real-time recording. If a clip was recorded, `setupAudioPlayer` and `setupAudioEngine` are called consequently.
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        playButton.tintColor = UIColor.GREEN
        if (recordedAudio.filePathUrl == nil) {
            // TODO: Real time mic to speaker
        } else {
            print(recordedAudio.filePathUrl)
            setupAudioPlayer()
            setupAudioEngine()
        }
        
    }
    
    /// `try` to create an `AVAudioPlayer` stored into `audioPlayer`.
    func setupAudioPlayer() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: recordedAudio.filePathUrl)
        } catch let error {
            print("audioPlayer failed to create...printing error: \n", error)
        }
    }
    
    /// This function creates an `AVAudioEngine` stored in `audioEngine`. It next creates an `AVAudioPlayerNode` and attaches it to `audioEngine`. Finally `equalizer` is initialized to `AVAudioUnitEQ` with 14 bands.
    func setupAudioEngine() {
        audioEngine = AVAudioEngine()
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attach(audioPlayerNode)
        equalizer = AVAudioUnitEQ(numberOfBands: 14)
        // TODO: find band values and attach the equalizer to the audioEngine
        
        print("bands: ")
//        eq.bands = [ 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 3072, 4096, 5120, 10240, 16384 ]
    }
    
    @IBAction func playAudio(_ sender: UIButton) {
        audioPlayer.play()
    }
    
}
