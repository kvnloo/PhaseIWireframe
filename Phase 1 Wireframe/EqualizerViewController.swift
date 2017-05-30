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
import VerticalSlider

class EqualizerViewController: GeneralUIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: IBOutlets
    
    /// This button allows the user to toggle between Record and Stop mode if in realTime, otherwise it will allow toggling between Play and Pause mode
    @IBOutlet weak var mainButton: UIButton!
    /// The `GeneralUITableView` that contains all of the bands for the `AVAudioUnitEQ`
    @IBOutlet weak var tableView: GeneralUITableView!
    
    // MARK: Global Variables
    
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
    
    /// A flag used to represent if in realTime or if audio clip was recorded on the previous `GeneralUIViewConroller`.
    var realTime: Bool!
    /// If in `realTime`, this flag determines if the class is in record mode or stop mode. If not in realTime, this flag determines if the class is in play mode or pause mode.
    var state: Bool = true
    
    // MARK: Lifecycle
    
    /// Set's the `mainButton` imageView based on `realTime`.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if recordedAudio == nil {
            self.mainButton
                .setImage(#imageLiteral(resourceName: "record-button"), for: .normal)
        }
    }
    /// Check if user recorded clip or if they want to use real-time recording. Set the value for `realTime` based on if recordedAudio is nil. Once `realTime` is set, `setupEqualizer` is called.
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if recordedAudio == nil {
            realTime = true
        } else {
            realTime = false
        }
        setupEqualizer(numberOfBands: 14)
    }
    
    // MARK: - TableView Setup
    
    /// Returns the number of sections in the TableView
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    /// Returns the height for row at `indexPath`.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2 {
            return 100
        }
        return 264
    }
    
    /// Returns the number of rows given the `section`.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else {
            return 3
        }
    }
    
    /// Returns the title for header given the `section`.
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Channel 0"
        default:
            return "Channel 1"
        }
    }
    
    /// Determines which cell to return based on the `indexPath`.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 2 {
            return tableView.dequeueReusableCell(withIdentifier: "EmptyCell") as! GeneralUITableViewCell
        } else {
            let cell: EqualizerTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SliderTableViewCell") as! EqualizerTableViewCell
            cell.row = indexPath.row
            return cell
        }
    }
    
    
    /// This function creates an `AVAudioEngine` stored in `audioEngine`. Then based on `realTime`, it sets up real-time multichannel microphone to speaker output or streams from an audio file. In both of these cases the input is sent to an equalizer that the user may modify. These two channels are then mixed together with `audioEngine.mainMixerNode`.
    func setupAudioEngine() {
        
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
                    failedToGetDesiredNumberOfChannels()
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
    
    func failedToGetDesiredNumberOfChannels() {
        // TODO: Notify User that only 1 channel is available
        var cell = tableView.cellForRow(at: IndexPath(row: 0, section: 1))
        cell?.isUserInteractionEnabled = false
        cell = tableView.cellForRow(at: IndexPath(row: 1, section: 1))
        cell?.isUserInteractionEnabled = false

    }
    
    /// Called in `viewDidLoad`, this function sets up the equalizer with 14 bands per channel.
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
    
    /// This function is called every time a `VerticalSlider` changes. It updates the actual gain values within each equalizer.
    func updateGains() {
        let leftBands = leftEqualizer.bands
        let rightBands = rightEqualizer.bands
        
        if let cell1 = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? EqualizerTableViewCell {
            for i in 0...6 {
                leftBands[i + 7].gain = (cell1.sliderStackView.subviews[i] as! VerticalSlider).value
            }
        }
        if let cell2 = tableView.cellForRow(at: IndexPath(row: 1, section: 0)) as? EqualizerTableViewCell {
            for i in 0...6 {
                leftBands[i].gain = (cell2.sliderStackView.subviews[i] as! VerticalSlider).value
            }
        }
        if let cell3 = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? EqualizerTableViewCell {
            for i in 0...6 {
                rightBands[i + 7].gain = (cell3.sliderStackView.subviews[i] as! VerticalSlider).value
            }
        }
        if let cell4 = tableView.cellForRow(at: IndexPath(row: 1, section: 1)) as? EqualizerTableViewCell {
            for i in 0...6 {
                rightBands[i].gain = (cell4.sliderStackView.subviews[i] as! VerticalSlider).value
            }
        }
        
    }
    
    /// This function is called if in real-time mode. It starts the recording process and streams the audio to speaker after digital signal processing.
    func startRecording() {
        setupAudioEngine()
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
    func stopRecording() {
        audioEngine.mainMixerNode.removeTap(onBus: 0)
        audioEngine.stop()
    }
    
    // MARK: - IBActions
    
    /// This IBAction is called by `mainButton`. Based on realTime and state, it manages setting the `imageView` for `mainButton`. As well as changing `state` for future toggles.
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
