//
//  AiBroViewController.swift
//  FleekSpaces
//
//  Created by Mayur P on 02/03/23.
//

import UIKit
import Speech
import OpenAISwift
import AVFoundation
import Lottie

class AiBroViewController: UIViewController, SFSpeechRecognizerDelegate {
    
    
    @IBOutlet weak var aiGreetingLabel: UILabel!
    
    @IBOutlet weak var muteBtn: UIButton!
    @IBOutlet weak var cahtLottieView: LottieAnimationView!
    
    @IBOutlet weak var waveforms: LottieAnimationView!
    @IBOutlet weak var lottieStuff: LottieAnimationView!
    @IBOutlet weak var mainMicBtn: UIButton!
    @IBOutlet weak var micImage: UIImageView!
    @IBOutlet weak var questionText: UITextView!
    @IBOutlet weak var answerText: UITextView!
    let notificationFeedback = UINotificationFeedbackGenerator()
          
    let synthesizer = AVSpeechSynthesizer()
    var client: OpenAISwift?
    var finalMessage = ""
    @IBOutlet weak var tapToSpeakLabel: UILabel!
    var saveMessage = ""
    var aiGreetinsSuggestions = ["Yo! I'm your AI Bro", "Hello & Welcome! I'm your AI Bro", "East of West, AI Bro is the best!", "Yo! Yo! Yo! I'm yo AI Bro", "My name is Bro, AI Bro!"]
    var greetingSuggestions = ["Ask for any movie recommendations", "Ask for any Tv show recommendations", "Ask what to watch on Netflix", "Ask for what to watch on Prime Video", "Ask for romantic movie suggestions", "Ask for any action movie suggestions"]
    
    var thinkingSuggestions = ["thinking", "let me think", "using my brain", "I got this", "calculating this", "wait for it"  ]
    
    //local prop
    let audioSession = AVAudioSession.sharedInstance()
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer()
    let request = SFSpeechAudioBufferRecognitionRequest()
    var task: SFSpeechRecognitionTask! = nil
    var isStart: Bool = false
    var isMute: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cahtLottieView.isHidden = true
        self.lottieStuff.isHidden = true
        waveforms.isHidden = true
        requestPermission()
        
        var randomGreeting = greetingSuggestions.randomElement()
        var randomAiTitle = aiGreetinsSuggestions.randomElement()
        
        if let safeRadomAiTitle = randomAiTitle {
            self.aiGreetingLabel.text = safeRadomAiTitle
            self.aiSpeakThis(voiceText: safeRadomAiTitle)
        }
        if let safeRandomtext = randomGreeting {
           
            self.questionText.text = safeRandomtext
        }
       
        self.answerText.text = ""
        setupAI()
        configureAudioSessionCategory()
        configureAudioSessionToSpeaker()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        self.synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
        
    }
    
    //MARK: - Setup AI
    func setupAI() {
        
        client = OpenAISwift(authToken: "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")
        
    }
    
    
    
    
    //MARK: - Make Ai Speak
    
    func aiSpeakThis(voiceText: String) {
        
        cahtLottieView.isHidden = false
        lottiePlaychatflow()
        let utterance = AVSpeechUtterance(string: voiceText)
//        utterance.voice = AVSpeechSynthesisVoice(language: "en-AU")
        utterance.voice =  AVSpeechSynthesisVoice( identifier: "com.apple.ttsbundle.Samantha-compact")
        utterance.rate = 0.5
        utterance.volume = 100.0

       
        synthesizer.speak(utterance)

    }
    
    //MARK: - AudioSession Config
    func configureAudioSessionCategory() {
      print("Configuring audio session")
      do {
        try audioSession.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.voiceChat)
        try audioSession.overrideOutputAudioPort(AVAudioSession.PortOverride.none)
        print("AVAudio Session out options: ", audioSession.currentRoute)
        print("Successfully configured audio session.")
      } catch (let error) {
        print("Error while configuring audio session: \(error)")
      }
    }

    func configureAudioSessionToSpeaker(){
        do {
            try audioSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
            try audioSession.setActive(true)
            print("Successfully configured audio session (SPEAKER-Bottom).", "\nCurrent audio route: ",audioSession.currentRoute.outputs)
        } catch let error as NSError {
            print("#configureAudioSessionToSpeaker Error \(error.localizedDescription)")
        }
    }
    
    //MARK: - Send message
    func send(text: String, completion: @escaping (String) -> Void) {
        client?.sendCompletion(with: text, maxTokens: 100, completionHandler: { result in
            switch result {
                
            case .success(let model):
                let output = model.choices.first?.text ?? ""
                completion(output)
                
            case .failure(let err):
                print("error in decoding \(err)")
                break
                
            }
        })
    }
    
    
    //Speech action comes here
    @IBAction func speechBtnTapped(_ sender: Any) {
        
        isStart = !isStart
        
        if isStart {
            notificationFeedback.notificationOccurred(.success)
            self.lottieStuff.isHidden = false
            self.waveforms.isHidden = false
            lottiePlayWave()
            lottiePlay()
            startSpeechRecognization()
            self.tapToSpeakLabel.text = "Tap to Send"
            self.answerText.text = "Listening..."
            self.micImage.isHidden = true
//            self.micImage.tintColor = .red
        } else {
            notificationFeedback.notificationOccurred(.success)
            self.lottieStuff.isHidden = true
            self.waveforms.isHidden = true
            cancelSpeechrecognization()
            if let safeThinkingText = thinkingSuggestions.randomElement() {
                self.answerText.text = "\(safeThinkingText)..."
                self.aiSpeakThis(voiceText: safeThinkingText)
            }
           
            self.tapToSpeakLabel.text = "Tap to Speak"
//            self.micImage.tintColor = UIColor(named: "Fleek_400")
            self.micImage.isHidden = false
            self.finalMessage = self.questionText.text
            
            print("FINAL : \(self.finalMessage)")
            
            send(text: self.finalMessage) { response in
                
                DispatchQueue.main.async {
                    self.answerText.text = response
                    self.aiSpeakThis(voiceText: response)

                }
               
  
                
            }
        }
    }
    
    //MARK: - lottie chat flow
    func lottiePlaychatflow() {
        
        // 1. Set animation content mode
          
          cahtLottieView.contentMode = .scaleAspectFill
          
          // 2. Set animation loop mode
          
        cahtLottieView.loopMode = .playOnce
          
          // 3. Adjust animation speed
          
        cahtLottieView.animationSpeed = 0.3
          
          // 4. Play animation
        cahtLottieView.play(completion: { _ in
            
//            self.dismissDelay()
            
            self.cahtLottieView.isHidden = true
            
        })
        
    }
    
    @IBAction func muteBtnTap(_ sender: Any) {
        
        isMute = !isMute
        if isMute {
            self.synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
            
            self.muteBtn.tintColor = .red
        } else {
            self.synthesizer.continueSpeaking()
            self.muteBtn.tintColor = .systemTeal
           
            
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
            
//            print("Final message \(self.saveMessage)")
//            self.saveMessage = message
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
    
    
    func lottiePlay() {
        
        // 1. Set animation content mode
          
          lottieStuff.contentMode = .scaleAspectFill
          
          // 2. Set animation loop mode
          
        lottieStuff.loopMode = .loop
          
          // 3. Adjust animation speed
          
        lottieStuff.animationSpeed = 1.0
          
          // 4. Play animation
        lottieStuff.play(completion: { _ in
            
//            self.dismissDelay()
            
        })
        
    }
    
    
    func lottiePlayWave() {
        
        // 1. Set animation content mode
          
          waveforms.contentMode = .scaleAspectFill
          
          // 2. Set animation loop mode
          
        waveforms.loopMode = .loop
          
          // 3. Adjust animation speed
          
        waveforms.animationSpeed = 0.6
          
          // 4. Play animation
        waveforms.play(completion: { _ in
            
//            self.dismissDelay()
            
        })
        
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
