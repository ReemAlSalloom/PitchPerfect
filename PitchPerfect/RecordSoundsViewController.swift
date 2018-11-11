//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Reem Saloom on 10/21/18.
//  Copyright © 2018 Reem AlSalloom. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var Recbtn: UIButton!
    @IBOutlet weak var stopBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      ToggleUI(recording: false)
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    @IBAction func RecordAudio(_ sender: Any) {
        
        ToggleUI(recording: true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: .default,  options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    // MARK: UI Toggle
    
    func ToggleUI(recording:Bool)
    {
        
        if recording {
            recordingLabel.text = "Recording in Progress!!"
            stopBtn.isEnabled = true
            Recbtn.isEnabled = false
        }
        else
        {
            recordingLabel.text = "Tap To Record!!"
            stopBtn.isEnabled = false
            Recbtn.isEnabled = true
        }
        
    }
    
    @IBAction func StopRecording(_ sender: Any) {
        
        ToggleUI(recording: false)
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false, options:  [])
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        if flag{
         performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        }
        else{
            
            print("saving recording failed ")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let soundVC = segue.destination as! PlaySoundViewController
            let recordurl = sender as! URL
            soundVC.recordedAudioURL = recordurl
        }
    }
    
}

