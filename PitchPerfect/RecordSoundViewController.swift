//
//  RecordSoundViewController
//  PitchPerfect
//
//  Created by Jaotct on 10/7/2561 BE.
//  Copyright © 2561 great corner. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController {

    @IBOutlet weak var recordingLable: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordButton: UIButton!
    
    private var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        stopRecordButton.isEnabled = false
    }

    @IBAction func recordAudio(_ sender: Any) {
        recordingLable.text = "Recording in Progress"
        toggleButton()
    }
    @IBAction func stopRecording(_ sender: Any) {
        recordingLable.text = "Tab to Record"
        toggleButton()
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true).first
        let recordingName = "/recordedVoice.wav"
        let filePathString = dirPath! + recordingName
        let filePath = URL(string: filePathString)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    
    
    private func toggleButton() {
        stopRecordButton.isEnabled = recordButton.isEnabled
        recordButton.isEnabled = !stopRecordButton.isEnabled
    }
}

