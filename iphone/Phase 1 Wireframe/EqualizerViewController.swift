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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        playButton.tintColor = UIColor.GREEN
        if (recordedAudio.filePathUrl == nil) {
            print("recording failed for some reason")
            // TODO: Notify user that the recording failed
        } else {
            print(recordedAudio.filePathUrl)
            setupAudioPlayer()
            setupAudioEngine()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupAudioPlayer() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: recordedAudio.filePathUrl)
        } catch let error {
            print("audioPlayer failed to create...printing error: \n", error)
        }
    }
    
    func setupAudioEngine() {
        audioEngine = AVAudioEngine()
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attach(audioPlayerNode)
        equalizer = AVAudioUnitEQ(numberOfBands: 14)
        print("bands: ")
//        eq.bands = [ 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 3072, 4096, 5120, 10240, 16384 ]
    }
    
    @IBAction func playAudio(_ sender: UIButton) {
        audioPlayer.play()
    }
    
}
