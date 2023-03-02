//
//  AiBroViewController.swift
//  FleekSpaces
//
//  Created by Mayur P on 02/03/23.
//

import UIKit
import Speech

class AiBroViewController: UIViewController, SFSpeechRecognizerDelegate {
    
    
    
    @IBOutlet weak var mainMicBtn: UIButton!
    @IBOutlet weak var micImage: UIImageView!
    @IBOutlet weak var questionText: UITextView!
    @IBOutlet weak var answerText: UITextView!
    
    @IBOutlet weak var tapToSpeakLabel: UILabel!
    var saveMessage = ""
    
    //local prop
    
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var task: SFSpeechRecognitionTask! = nil
    var isStart: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestPermission()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func speechBtnTapped(_ sender: Any) {
        
        isStart = !isStart
        
        if isStart {
            startSpeechRecognization()
            self.tapToSpeakLabel.text = "Listening"
            self.micImage.tintColor = .red
        } else {
            cancelSpeechrecognization()
            self.tapToSpeakLabel.text = "Tap to Speak"
            self.micImage.tintColor = UIColor(named: "Fleek_400")
        }
    }
    
    
    //MARK: - Start Speech recognition
    func startSpeechRecognization() {
        
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffe, _ in
            
            self.request.append(buffe)
            
            
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch let error {
            print("Error recognizing the voice")
        }
        
        guard let myRecognization = SFSpeechRecognizer() else {
            print("Recignization is not available")
            return
        }
        
        if !myRecognization.isAvailable {
            print("Not available now, try again after some time")
        }
        
        
        task = speechRecognizer?.recognitionTask(with: request, resultHandler: { responses, err in
            
            
            guard let response = responses else {
                if err != nil {
                    print("error is here \(err)")
                }
                return
            }
            
            
            
            let message = response.bestTranscription.formattedString
            
            self.saveMessage = message
            if !self.saveMessage.isEmpty {
                self.questionText.text = message
            }
            
            self.saveMessage = message
        })
        
        
    }
    
    
    func cancelSpeechrecognization() {
        
        self.questionText.text = self.saveMessage
        task.finish()
        task.cancel()
        task = nil
        
        request.endAudio()
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        
    }
    
    //MARK: - Get Permission
    func requestPermission() {
        //handle mic disabled when off
        SFSpeechRecognizer.requestAuthorization { (authState) in
            OperationQueue.main.addOperation {
                if authState == .authorized {
                    print("Accepted")
                    self.mainMicBtn.isEnabled = true
                } else if authState == .denied {
                    print("Denied")
                    self.mainMicBtn.isEnabled = false
                } else if authState == .notDetermined {
                    print("user has not speech recognization")
                } else if authState == .restricted {
                    print("user has been restricted from using speech recognization")
                }
            }
        }
    }
    
    
}
