//
//  AudioSingletons.swift
//  Phase 1 Wireframe
//
//  Created by Kevin Rajan on 5/29/17.
//  Copyright © 2017 veeman961. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation


class Audio {
    
    /// The audio engine that is used for all audio effects
    var audioEngine: AVAudioEngine = AVAudioEngine()
    
    /// The `audioPlayerNode` is used if the user recorded on the previous screen
    var audioPlayerNode: AVAudioPlayerNode!
    /// The `audioSession` is used if in realTime
    var audioSession: AVAudioSession!
    
    /// The equalizer for the 0th channel
    var leftEqualizer: AVAudioUnitEQ!
    /// The equalizer for the 1th channel
    var rightEqualizer: AVAudioUnitEQ!
    
    /// The mixer is used to mix together multichannel audio
    var audioMixerNode: AVAudioMixerNode!
    
    /// Information regarding the recorded clip from the previous `GeneralUIViewController`.
    var recordedAudio: RecordedAudioObject!
    /// The audio file in which this class attempts to record.
    var audioFile: AVAudioFile!
    
    /// The `AVAudioRecorder' that performs recording from the microphone.
    var recorder: AVAudioRecorder?
    /// The `AVAudioRecorderDelegate' that must be passed into `recorder.
    var recorderDelegate: AVAudioRecorderDelegate? {
        didSet {
            recorder?.delegate = recorderDelegate
        }
    }
    
    // Define identifier
    let notificationName = Notification.Name("NotificationIdentifier")
    
    typealias HandlerFunction = ()  -> Void

    
    
    static let sharedInstance = Audio()
    
    private init() {
        audioSession = AVAudioSession.sharedInstance()
    }
    
    /// Creates an `AVAudioSession` as a `sharedInstance` then requests recording permission from the user. If the user allows recording, the `AVAudioSession` has settings changed and the `record` method is called.
    func setupAVAudioSession() {
        //make an AudioSession and request recording permission
        let audioSession = AVAudioSession.sharedInstance()
        audioSession.requestRecordPermission { [unowned self] allowed in
            if allowed { // Microphone allowed, do what you like!
                
                // settings for a high-quality single-channel recording session
                let settings = [
                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                    AVSampleRateKey: 44100,
                    AVNumberOfChannelsKey: 2,
                    AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
                ]
                self.recordWithAVAudioRecorder(filename: "audioFileName.m4a", settings: settings, metered: false, timeIntervalForResults: 0.5)
            } else {
                // Microphone permission denied
                print("Failed to get recording permission")
            }
        }
    }
    
    /// Called in other VC's `viewDidLoad`, this function sets up the equalizer with 14 bands per channel.
    func setupEqualizer(numberOfBands: Int) {
        
        leftEqualizer = AVAudioUnitEQ(numberOfBands: numberOfBands)
        rightEqualizer = AVAudioUnitEQ(numberOfBands: numberOfBands)
        
        let leftBands  = leftEqualizer.bands
        let rightBands = rightEqualizer.bands
        let freqs = [ 8, 16, 32, 64, 128, 256, 512, 1024, 2048, 3072, 4096, 5120, 10240, 16384 ]
        
        // audioEngine.connect(audioPlayerNode, to: changeAudioUnitTime, format: nil)
        // audioEngine.connect(changeAudioUnitTime, to: audioEngine.outputNode, format: nil)
        // changeAudioUnitTime.pitch = 800
        
        for i in 0...(leftBands.count - 1) {
            leftBands[i].bypass     = false
            leftBands[i].frequency  = Float(freqs[i])
            leftBands[i].filterType = .parametric
            leftBands[i].bandwidth  = 5.0
            
            rightBands[i].bypass     = false
            rightBands[i].frequency  = Float(freqs[i])
            rightBands[i].filterType = .parametric
            rightBands[i].bandwidth  = 5.0
        }
    }
    
    /// This function creates an `AVAudioEngine` stored in `audioEngine`. Then based on `realTime`, it sets up real-time multichannel microphone to speaker output or streams from an audio file. In both of these cases the input is sent to an equalizer that the user may modify. These two channels are then mixed together with `audioEngine.mainMixerNode`.
    func setupAudioEngine(realTime: Bool, handler: @escaping HandlerFunction) {
        
        audioEngine.stop()
        audioEngine.reset()
        audioEngine = AVAudioEngine()
        
        audioEngine.attach(leftEqualizer)
        audioEngine.attach(rightEqualizer)
        
        audioMixerNode = audioEngine.mainMixerNode
        
        if realTime {
            print("real-time")
            audioPlayerNode = AVAudioPlayerNode()
            
            do {
                audioSession = AVAudioSession.sharedInstance()
                try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
                let ioBufferDuration = 128.0 / 44100.0
                try audioSession.setPreferredIOBufferDuration(ioBufferDuration)
                let desiredNumChannels = 2
                if audioSession.outputNumberOfChannels >= desiredNumChannels {
                    try! audioSession.setPreferredOutputNumberOfChannels(desiredNumChannels)
                } else {
                    handler()
                }
            } catch {
                assertionFailure("AVAudioSession setup error: \(error)")
            }
            
            
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let docsDirect = paths[0]
            
            do {
                let audioUrl = docsDirect.appendingPathComponent("recording.caf")
                let settings = [
                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                    AVSampleRateKey: 44100,
                    AVNumberOfChannelsKey: 2,
                    AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
                ]
                audioFile = try AVAudioFile(forWriting: audioUrl, settings: settings)
            } catch _ {
                print("FAILED")
            }
            
            let input = audioEngine.inputNode!
            let format = input.inputFormat(forBus: 0)
            
            audioEngine.attach(audioPlayerNode)
            let output = audioEngine.outputNode
            let outputHWFormat = output.outputFormat(forBus: 0)
            audioEngine.connect(audioMixerNode, to: output, format: outputHWFormat)
            let connectionPoints = [
                AVAudioConnectionPoint(node: leftEqualizer, bus: 0),
                AVAudioConnectionPoint(node: rightEqualizer, bus: 0)]
            audioEngine.connect(input, to: connectionPoints, fromBus: 0, format: format)
            audioEngine.connect(leftEqualizer, to: audioMixerNode, format: nil)
            audioEngine.connect(rightEqualizer, to: audioMixerNode, format: nil)
        } else {
            audioPlayerNode = AVAudioPlayerNode()
            audioEngine.attach(audioPlayerNode!)
            let format = audioPlayerNode.outputFormat(forBus: 0)
            let connectionPoints = [
                AVAudioConnectionPoint(node: leftEqualizer, bus: 0),
                AVAudioConnectionPoint(node: rightEqualizer, bus: 0)]
            audioEngine.connect(audioPlayerNode, to: connectionPoints, fromBus: 0, format: format)
            audioEngine.connect(leftEqualizer, to: audioMixerNode, format: nil)
            audioEngine.connect(rightEqualizer, to: audioMixerNode, format: nil)
            do {
                audioFile = try AVAudioFile(forReading: recordedAudio.filePathUrl)
                audioEngine.prepare()
                try audioEngine.start()
//                let audioFormat = audioFile.processingFormat
//                let audioFrameCount = UInt32(audioFile.length)
//                let audioFileBuffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: audioFrameCount)
//                try audioFile.read(into: audioFileBuffer, frameCount: audioFrameCount)
                schedule()
                
            } catch _ {}
        }
    }
    
    func schedule() {
        audioPlayerNode.scheduleFile(audioFile, at: nil, completionHandler: {
            self.audioPlayerNode.pause()
            // Post notification
            print("notification posted")
            NotificationCenter.default.post(name: self.notificationName, object: nil)
            self.schedule()
        })
    }
    
    func recordWithAVAudioRecorder(filename: String, settings: [String:Int], metered: Bool, timeIntervalForResults: TimeInterval) {
        // Get path for app directory
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docsDirect = paths[0]
        let audioUrl:URL = docsDirect.appendingPathComponent(filename)
        
        // create the session
        let session = AVAudioSession.sharedInstance()
        do {
            // configure the session for recording and playback
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
            try session.setActive(true)
            // create the audio recording, and assign ourselves as the delegate
            recorder = try AVAudioRecorder(url: audioUrl, settings: settings)
            recorder?.delegate = recorderDelegate
            recorder?.prepareToRecord()
            recorder?.isMeteringEnabled = metered
        }
        catch let error {
            print("recording failed...printing error: \n", error)
        }
    }
    
    /// This function is called if in real-time mode. It starts the recording process and streams the audio to speaker after digital signal processing.
    func startRecordingWithAudioEngine() {
        try! audioEngine.start()
        let format = audioMixerNode.outputFormat(forBus: 0)
        audioMixerNode.installTap(onBus: 0, bufferSize: 1024, format: format, block:
            { (buffer: AVAudioPCMBuffer!, time: AVAudioTime!) -> Void in
                print(NSString(string: "writing"))
                do{
                    if self.audioFile == nil {
                        print("was nil")
                    }
                    try self.audioFile.write(from: buffer)
                }
                catch {
                    print(NSString(string: "Write failed"));
                }
        })
    }
    
    /// This function is called if in real-time mode. It stops the recording process and stops the audioEngine after removing the recording tap.
    func stopRecordingWithAudioEngine() {
        audioEngine.mainMixerNode.removeTap(onBus: 0)
        audioEngine.stop()
    }
    
    func playWithAudioPlayerNode() {
        audioPlayerNode?.play()
    }
    
    func pauseWithAudioPlayerNode() {
        audioPlayerNode?.pause()
    }
    
    /// If the recording succeeded store the URL of the recorded clip then call `performeSegue`. Else notify the user that recording failed.
    func recordingEndedSuccessfully() {
        // Initialize RecordedAudioObject
        Audio.sharedInstance.recordedAudio = RecordedAudioObject()
        Audio.sharedInstance.recordedAudio.filePathUrl = Audio.sharedInstance.recorder?.url
        Audio.sharedInstance.recordedAudio.title       = Audio.sharedInstance.recorder?.url.lastPathComponent
    }

}
