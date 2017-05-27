//
//  EqualizerViewController.swift
//  Phase 1 Wireframe
//
//  Created by Kevin Rajan on 5/25/17.
//  Copyright © 2017 veeman961. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation
import CoreAudio

class RecorderViewController: GeneralUIViewController, AVAudioRecorderDelegate {

    // MARK: - IBOutlets
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordingLabel: GeneralUILabel!
    
    // MARK: - Global Variables
    var state: Bool! // This will decide if the button should be a mic or the pause button
    var recorder: AVAudioRecorder?
    var levelTimer = Timer()
    var audioUrl:URL!

    
    // MARK: - GeneralUIViewController Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Do any additional setup after calling super classes function
        stopButton.isHidden = true
        recordingLabel.isHidden = true
        recordButton.imageView?.contentMode = .scaleAspectFit
        stopButton.imageView?.contentMode   = .scaleAspectFit
        recordButton.tintColor = UIColor.RED
        stopButton.tintColor   = UIColor.WHITE
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        state = true
        recordingLabel.font = UIFont.CAPTION
        
        // Setup Audio session
        setupAVAudioSession()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if (segue.identifier == "SegueToEqualizerPlayer") {
            let vc = segue.destination as! EqualizerViewController
            vc.audioUrl = self.audioUrl
        }
    }

    // MARK: AVAudioRecorder
    func setupAVAudioSession() {
        //make an AudioSession and request recording permission
        let audioSession = AVAudioSession.sharedInstance()
        audioSession.requestRecordPermission { [unowned self] allowed in
            if (allowed) { // Microphone allowed, do what you like!
                
                // settings for a high-quality single-channel recording session
                let settings = [
                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                    AVSampleRateKey: 44100,
                    AVNumberOfChannelsKey: 2,
                    AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
                ]
                self.record(filename: "audioFileName.m4a", settings: settings, metered: false, timeIntervalForResults: 0.5)
            } else {
                // Microphone permission denied
                print("Failed to get recording permission")
            }
        }
    }
    
    func record(filename: String, settings: [String:Int], metered: Bool, timeIntervalForResults: TimeInterval) {
        // Get path for app directory
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docsDirect = paths[0]
        audioUrl = try docsDirect.appendingPathComponent(filename)
        
        // create the session
        let session = AVAudioSession.sharedInstance()
        do {
            // configure the session for recording and playback
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
            try session.setActive(true)
            // create the audio recording, and assign ourselves as the delegate
            recorder = try AVAudioRecorder(url: audioUrl, settings: settings)
            recorder?.delegate = self
            recorder?.prepareToRecord()
            recorder?.isMeteringEnabled = metered
        }
        catch let error {
            print("recording failed...printing error: \n", error)
        }
    }
    
    @IBAction func toggleRecording(_ sender: UIButton) {
        
        stopButton.isHidden = false
        if(state) {
            recorder?.record()
            state = false
            recordButton.setImage(#imageLiteral(resourceName: "pause-button"), for: .normal)
            recordButton.tintColor = UIColor.YELLOW
            recordingLabel.isHidden = false
        } else {
            recorder?.pause()
            state = true
            recordButton.setImage(#imageLiteral(resourceName: "microphone-2"), for: .normal)
            recordButton.tintColor = UIColor.RED
            recordingLabel.isHidden = true
        }
        
    }
    
    
    @IBAction func stopRecording(_ sender: UIButton) {
        recorder?.stop()
        print("stopped recording")
        
    }

    
    
}
