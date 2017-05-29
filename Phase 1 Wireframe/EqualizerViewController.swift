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
    @IBOutlet weak var mainButton: UIButton!
    
    // MARK: Global Variables
    
    var audioEngine: AVAudioEngine = AVAudioEngine()
    
    var audioPlayerNode: AVAudioPlayerNode!
    var audioSession: AVAudioSession!
    
    var leftEqualizer: AVAudioUnitEQ!
    var rightEqualizer: AVAudioUnitEQ!
    
    var audioMixerNode: AVAudioMixerNode!
    
    var recordedAudio: RecordedAudioObject!
    var audioFile: AVAudioFile!
    
    var state: Bool = true
    var realTime: Bool!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (recordedAudio == nil) {
            mainButton
                .setImage(#imageLiteral(resourceName: "record-button"), for: .normal)
        }
    }
    /// Check if user recorded clip or if they want to use real-time recording. If a clip was recorded, `setupAudioPlayer` and `setupAudioEngine` are called consequently.
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if (recordedAudio == nil) {
            realTime = true
        } else {
            realTime = false
        }
    }
    
    /// This function creates an `AVAudioEngine` stored in `audioEngine`. It next creates an `AVAudioPlayerNode` and attaches it to `audioEngine`. Finally `equalizer` is initialized to `AVAudioUnitEQ` with 14 bands.
    func setup(numberOfBands: Int) {
        
        audioEngine.stop()
        audioEngine.reset()
        audioEngine = AVAudioEngine()
        
        leftEqualizer = AVAudioUnitEQ(numberOfBands: numberOfBands)
        rightEqualizer = AVAudioUnitEQ(numberOfBands: numberOfBands)
        
        audioEngine.attach(leftEqualizer)
        audioEngine.attach(rightEqualizer)
        
        audioMixerNode = audioEngine.mainMixerNode
        
        if realTime {
            print("real-time")
            audioPlayerNode = AVAudioPlayerNode()
            
            do {
                audioSession = try AVAudioSession.sharedInstance()
                try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
                let ioBufferDuration = 128.0 / 44100.0
                try audioSession.setPreferredIOBufferDuration(ioBufferDuration)
                let desiredNumChannels = 2
                if audioSession.outputNumberOfChannels >= desiredNumChannels {
                    try! audioSession.setPreferredOutputNumberOfChannels(desiredNumChannels)
                } else {
                    // TODO: grey out one channel
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
            audioEngine.connect(audioPlayerNode!, to: leftEqualizer, format: nil)
            audioEngine.connect(leftEqualizer, to: audioEngine.outputNode, format: nil)

        }

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
        
        leftBands[8].gain = -10.0
        leftBands[9].gain = -10.0
        leftBands[10].gain = 10.0
        leftBands[11].gain = 10.0
        leftBands[12].gain = 10.0
        
        rightBands[8].gain = -10.0
        rightBands[9].gain = -10.0
        rightBands[10].gain = 10.0
        rightBands[11].gain = 10.0
        rightBands[12].gain = 10.0
        

        
        do {
            if realTime {
                
            } else {
                audioFile = try AVAudioFile(forReading: recordedAudio.filePathUrl)
                audioEngine.prepare()
                try audioEngine.start()
                audioPlayerNode?.scheduleFile(audioFile, at: nil, completionHandler: nil)
            }
        } catch _ {}
        
        
        
        
    }
    
    func startRecording() {
        setup(numberOfBands: 14)
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
    
    func stopRecording() {
        audioEngine.mainMixerNode.removeTap(onBus: 0)
        audioEngine.stop()
    }
    
    @IBAction func toggleAudio(_ sender: UIButton) {
        if realTime {
            if state {
                startRecording()
                mainButton.setImage(#imageLiteral(resourceName: "stop-button"), for: .normal)
                state = false
            } else {
                stopRecording()
                mainButton.setImage(#imageLiteral(resourceName: "record-button"), for: .normal)
                state = true
            }
        } else {
            if state {
                audioPlayerNode?.play()
                mainButton.setImage(#imageLiteral(resourceName: "pause-button"), for: .normal)
                state = false
            } else {
                audioPlayerNode?.pause()
                mainButton.setImage(#imageLiteral(resourceName: "play-button"), for: .normal)
                state = true
            }
        }
    }
    
}
