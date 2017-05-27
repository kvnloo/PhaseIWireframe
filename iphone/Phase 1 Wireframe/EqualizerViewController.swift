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

class EqualizerViewController: GeneralUIViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var playButton: UIButton!
    
    // MARK: Global Variables
    var audioUrl: URL!
    var audioPlayer: AVAudioPlayer!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        playButton.tintColor = UIColor.GREEN
        if (audioUrl == nil) {
            print("recording failed for some reason")
            // TODO: Notify user that the recording failed
        } else {
            print(audioUrl)
            setupAudioPlayer()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupAudioPlayer() {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioUrl)
        } catch let error {
            print("audioPlayer failed to create...printing error: \n", error)
        }
    }
    
    @IBAction func playAudio(_ sender: UIButton) {
        audioPlayer.play()
    }
    
}
