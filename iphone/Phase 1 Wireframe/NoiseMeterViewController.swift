//
//  NoiseMeterViewController.swift
//  Phase 1 Wireframe
//
//  Created by Kevin Rajan on 5/25/17.
//  Copyright © 2017 veeman961. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation
import CoreAudio

class NoiseMeterViewController: GeneralUIViewController,  AVAudioRecorderDelegate {
    
    // MARK: - IBOutlets
    @IBOutlet weak var noiseLevelLabel: GeneralUILabel!
    @IBOutlet weak var dbLabel: GeneralUILabel!
    
    @IBOutlet weak var silentLabel: GeneralUILabel!
    @IBOutlet weak var quietLabel: GeneralUILabel!
    @IBOutlet weak var averageLabel: GeneralUILabel!
    @IBOutlet weak var noisyLabel: GeneralUILabel!
    @IBOutlet weak var loudLabel: GeneralUILabel!
    
    @IBOutlet weak var noiseMeterViewOne: UIView!
    @IBOutlet weak var noiseMeterViewTwo: UIView!
    @IBOutlet weak var noiseMeterViewThree: UIView!
    @IBOutlet weak var noiseMeterViewFour: UIView!
    @IBOutlet weak var noiseMeterViewFive: UIView!
    
    // MARK: - Global Variables
    var recorder: AVAudioRecorder?
    var levelTimer = Timer()
//    var lowPassResults: Double = 0.0
    var dBs: NSArray = NSArray()
    
    // MARK: - GeneralUIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Setup UI Elements
        setupNoiseMeter()
        noiseLevelLabel.font = UIFont.LARGE
        dbLabel.font = UIFont.LARGE
        
        
        // Setup Audio Session
        setupAVAudioSession()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Logic
    func setupAVAudioSession() {
        //make an AudioSession and request recording permission
        let audioSession = AVAudioSession.sharedInstance()
        audioSession.requestRecordPermission { [unowned self] allowed in
            if (allowed) { // Microphone allowed, do what you like!
                
                // settings for a high-quality single-channel recording session
                let settings = [
                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                    AVSampleRateKey: 44100,
                    AVNumberOfChannelsKey: 1,
                    AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
                ]
                self.record(filename: "audioFileName.m4a", settings: settings, metered: true, timeIntervalForResults: 0.5)
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
        let audioUrl = try docsDirect.appendingPathComponent(filename)
        
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
            recorder?.record()
            if(metered) {
                //instantiate a timer to be called with whatever frequency we want to grab metering values
                self.levelTimer = Timer.scheduledTimer(timeInterval: timeIntervalForResults, target: self, selector: #selector(NoiseMeterViewController.levelTimerCallback), userInfo: nil, repeats: true)
            }
        } 
        catch let error {
            print("recording failed...printing error: \n", error)
        }
    }
    
    func levelTimerCallback() {
        //we have to update meters before we can get the metering values
        recorder!.updateMeters()

        // print("channel 0: ", recorder!.averagePower(forChannel: 0))
        let dB = convertToDecibel(originalValue: recorder!.averagePower(forChannel: 0))
        updateLabels(dB: dB)
    }
    
    func updateLabels(dB: Float) {
        noiseLevelLabel.text = String(Int(dB))
        if(dB < 50) {
            noiseLevelLabel.textColor = UIColor.BLUE
            dbLabel.textColor = UIColor.BLUE
        } else if(dB < 75) {
            noiseLevelLabel.textColor = UIColor.GREEN
            dbLabel.textColor = UIColor.GREEN
        }  else if(dB < 90) {
            noiseLevelLabel.textColor = UIColor.YELLOW
            dbLabel.textColor = UIColor.YELLOW
        } else if(dB < 100) {
            noiseLevelLabel.textColor = UIColor.ORANGE
            dbLabel.textColor = UIColor.ORANGE
        }  else if(dB < 120) {
            noiseLevelLabel.textColor = UIColor.RED
            dbLabel.textColor = UIColor.RED
        }
    }
    
    func convertToDecibel (originalValue: Float) -> Float {
        var level: Float
        let min:Float = -80.0
        
        if (originalValue < min) {
            level = 0.0
        } else if (originalValue >= 0.0) {
            level = 1.0
        } else {
            let root:Float            = 2.0
            let minAmp:Float          = powf(10.0, 0.05 * min)
            let inverseAmpRange:Float = 1.0 / (1.0 - minAmp)
            let amp:Float             = powf(10.0, 0.05 * originalValue)
            let adjAmp:Float          = (amp - minAmp) * inverseAmpRange
            level                     = powf(adjAmp, 1.0 / root)
        }
        return level * 120
    }
    
    func setupNoiseMeter() {
        noiseMeterViewOne.backgroundColor   = UIColor.BLUE
        noiseMeterViewTwo.backgroundColor   = UIColor.GREEN
        noiseMeterViewThree.backgroundColor = UIColor.YELLOW
        noiseMeterViewFour.backgroundColor  = UIColor.ORANGE
        noiseMeterViewFive.backgroundColor  = UIColor.RED
        silentLabel.font  = UIFont.CAPTION
        quietLabel.font   = UIFont.CAPTION
        averageLabel.font = UIFont.CAPTION
        noisyLabel.font   = UIFont.CAPTION
        loudLabel.font    = UIFont.CAPTION
    }
    
    // MARK: AVAudioRecorderDelegate
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            recordingEnded(success: false)
        } else {
            recordingEnded(success: true)
        }
    }
    
    func recordingEnded(success: Bool) {
        if(success) {
            print("RECORDING SUCCEEDED")
        } else {
            print("RECORDING FAILED")
        }
    }
    
    
    
}
