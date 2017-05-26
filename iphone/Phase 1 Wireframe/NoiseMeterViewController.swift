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
    @IBOutlet weak var noiseMeterStackView: UIStackView!
    
    // MARK: - Global Variables
    var recorder: AVAudioRecorder?
    var levelTimer = Timer()
    var lowPassResults: Double = 0.0
    var dBs: NSArray = NSArray()
    
    // MARK: - GeneralUIViewController Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        colorViews()
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Logic
    func setup() {
        //make an AudioSession, set it to PlayAndRecord and make it active
        let audioSession = AVAudioSession.sharedInstance()
        audioSession.requestRecordPermission { [unowned self] allowed in
            if (allowed) {
                // Microphone allowed, do what you like!
                print("GOT PERMISSION")
                self.record()
                
            } else {
                // Microphone permission denied
                
            }
        }
        /*
        audioSession.setCategory(.defaultToSpeaker, error: nil)
        audioSession.setActive(true, error: nil)
        
        
        // make a dictionary to hold the recording settings so we can instantiate our AVAudioRecorder
        var recordSettings: [NSObject : AnyObject] = [AVFormatIDKey:kAudioFormatAppleIMA4,
                                                      AVSampleRateKey:44100.0,
                                                      AVNumberOfChannelsKey:2,AVEncoderBitRateKey:12800,
                                                      AVLinearPCMBitDepthKey:16,
                                                      AVEncoderAudioQualityKey:AVAudioQuality.Max.rawValue
            
        ]
        
        //declare a variable to store the returned error if we have a problem instantiating our AVAudioRecorder
        var error: NSError?
        
        //Instantiate an AVAudioRecorder
        recorder = AVAudioRecorder(URL:nil, settings: recordSettings, error: &error)
        //If there's an error, print that shit - otherwise, run prepareToRecord and meteringEnabled to turn on metering (must be run in that order)
        if let e = error {
            print(e.localizedDescription)
        } else {
            recorder.prepareToRecord()
            recorder.isMeteringEnabled = true
            
            //start recording
            recorder.record()
            
            //instantiate a timer to be called with whatever frequency we want to grab metering values
            self.levelTimer = Timer.scheduledTimerWithTimeInterval(0.02, target: self, selector: Selector("levelTimerCallback"), userInfo: nil, repeats: true)
            
        }
 */
    }
    func record() {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docsDirect = paths[0]
        let audioUrl = try docsDirect.appendingPathComponent("audioFileName.m4a")
        // create the session
        let session = AVAudioSession.sharedInstance()
        do {
            // configure the session for recording and playback
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
            try session.setActive(true)
            // set up a high-quality recording session
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            // create the audio recording, and assign ourselves as the delegate
            recorder = try AVAudioRecorder(url: audioUrl, settings: settings)
            recorder?.delegate = self
            recorder?.prepareToRecord()
            recorder?.isMeteringEnabled = true
            recorder?.record()
            //instantiate a timer to be called with whatever frequency we want to grab metering values
            self.levelTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(NoiseMeterViewController.levelTimerCallback), userInfo: nil, repeats: true)
        } 
        catch let error {
            // failed to record!
            print("failed to record!")
            print(error)
        }
    }
    
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
    
    func levelTimerCallback() {
        //we have to update meters before we can get the metering values
        recorder!.updateMeters()
        
        print("channel 0: ", recorder!.averagePower(forChannel: 0))
        let dB = convertToDecibel(originalValue: recorder!.averagePower(forChannel: 0))
        updateLabels(dB: dB)
        
        // print("channel 1: ", recorder!.averagePower(forChannel: 1))
        /*
        if recorder!.averagePower(forChannel: 0) > -7 {
            print("Dis be da level I'm hearin' you in dat mic ")
            print(recorder!.averagePower(forChannel: 0))
            print("Do the thing I want, mofo")
        }*/
    }
    
    func updateLabels(dB: Float) {
        
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
    
    func colorViews() {
        var views = noiseMeterStackView.subviews
        views[0].backgroundColor = UIColor.BLUE
        views[1].backgroundColor = UIColor.GREEN
        views[2].backgroundColor = UIColor.YELLOW
        views[3].backgroundColor = UIColor.ORANGE
        views[4].backgroundColor = UIColor.RED
    }
    
    
    
}
