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
    
    /// The `UIButton` to start recording.
    @IBOutlet weak var recordButton: UIButton!
    /// The `UIButton` to stop recording.
    @IBOutlet weak var stopButton: UIButton!
    /// The `GeneralUILabel` that displays if in record mode.
    @IBOutlet weak var recordingLabel: GeneralUILabel!
    
    // MARK: - Global Variables
    /// The state of the recorder -> true if recording, false if paused or stopped.
    var state: Bool! // This will decide if the button should be a mic or the pause button
    /// The `AVAudioRecorder' that performs recording from the microphone.
    var recorder: AVAudioRecorder?
    /// The `RecordedAudioObject' object to store information of the user's recording.
    var recordedAudio: RecordedAudioObject!
    
    // MARK: - GeneralUIViewController Methods
    
    /// Hide `stopButton` and `recordingLabel`. This must be done since the user should not be able to stop the recording before it even starts.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Do any additional setup after calling super classes function
        stopButton.isHidden = true
        recordingLabel.isHidden = true
        
    }
    
    /// Set the state and font of the `recordingLabel`. Call `setupAVAudioSession` to initiate the recording process.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        state = true
        recordingLabel.font = UIFont.CAPTION
        
        // Setup Audio session
        setupAVAudioSession()
    }
    
    // MARK: Navigation
    
    /// Overridden to send `RecordedAudioObject` to the next `GeneralUIViewController` that we are seguing to. In this case the only possible segue is to `EqualizerViewController`.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if (segue.identifier == "SegueToEqualizerPlayer") {
            let vc = segue.destination as! EqualizerViewController
            let data = sender as! RecordedAudioObject
            vc.recordedAudio = data
        }
    }

    // MARK: AVAudioRecorder
    
    /// Creates an `AVAudioSession` as a `sharedInstance` then requests recording permission from the user. If the user allows recording, the `AVAudioSession` has settings changed and the `record` method is called.
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
    
    /// A function that allows the `recorder` to record storing the file at `filename (@param)`, with settings `settings (@param)`, a flag to determine if the recording should be metered, and a timeInterval for `levelTimer`.
    func record(filename: String, settings: [String:Int], metered: Bool, timeIntervalForResults: TimeInterval) {
        // Get path for app directory
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docsDirect = paths[0]
        let audioUrl:URL = try docsDirect.appendingPathComponent(filename)
        
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
    
    // MARK: AVAudioRecorderDelegate
    
    /// Ensures that when the recording ends a sucess or failure flag is sent to `recordingEnded` function.
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            recordingEnded(success: true)
        } else {
            recordingEnded(success: false)
        }
    }
    
    /// If the recording succeeded store the URL of the recorded clip then call `performeSegue`. Else notify the user that recording failed.
    func recordingEnded(success: Bool) {
        if(success) {
            // Initialize RecordedAudioObject
            recordedAudio = RecordedAudioObject()
            recordedAudio.filePathUrl = recorder?.url
            recordedAudio.title       = recorder?.url.lastPathComponent
            // Perform Segue to EqualizerPlayer
            self.performSegue(withIdentifier: "SegueToEqualizerPlayer", sender: recordedAudio)
        } else {
            // TODO: notify user of failure.
            print("RECORDING FAILED")
        }
    }
    
    // MARK: IBActions
    
    /// Toggle the state - this function handles the logic of switching the state. Hiding and unhiding different views.
    @IBAction func toggleRecording(_ sender: UIButton) {
        stopButton.isHidden = false
        if(state) {
            recorder?.record()
            state = false
            recordButton.setImage(#imageLiteral(resourceName: "pause-button"), for: .normal)
            recordButton.tintColor = UIColor.ORANGE
            recordingLabel.isHidden = false
        } else {
            recorder?.pause()
            state = true
            recordButton.setImage(#imageLiteral(resourceName: "microphone-2"), for: .normal)
            recordButton.tintColor = UIColor.RED
            recordingLabel.isHidden = true
        }
    }
    
    /// Stop recording. Calls the `stop` function.
    @IBAction func stopRecording(_ sender: UIButton) {
        recorder?.stop()
        print("stopped recording")
        
    }
    
}
