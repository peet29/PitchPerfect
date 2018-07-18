//
//  RecordSoundViewController
//  PitchPerfect
//
//  Created by Jaotct on 10/7/2561 BE.
//  Copyright © 2561 great corner. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordingLable: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordButton: UIButton!
    
    private var audioRecorder: AVAudioRecorder!
    
    enum ButtonState { case recording, notRecording }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        stopRecordButton.isEnabled = false
    }
    
    @IBAction func recordAudio(_ sender: Any) {
        buttonConfig(.recording)
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true).first
        let recordingName = "/recordedVoice.wav"
        let filePathString = dirPath! + recordingName
        let filePath = URL(string: filePathString)
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    @IBAction func stopRecording(_ sender: Any) {
        buttonConfig(.notRecording)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    private func buttonConfig( _ buttonState:ButtonState) {
        switch buttonState {
        case .recording:
            recordingLable.text = "Recording in Progress"
            toggleButton()
        case .notRecording:
            recordingLable.text = "Tab to Record"
            toggleButton()
        }
    }
    
    private func toggleButton(){
        stopRecordButton.isEnabled = recordButton.isEnabled
        recordButton.isEnabled = !stopRecordButton.isEnabled
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }else {
            print("recording Fail")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundVC = segue.destination as! PlaySoundViewController
            let recordedAudioURL = sender as! URL
            playSoundVC.recordedAudioURL = recordedAudioURL
        }
    }
    
}

