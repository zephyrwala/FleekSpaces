//
//  LoadsViewController.swift
//  FleekSpaces
//
//  Created by Mayur P on 22/02/23.
//

import UIKit
import Lottie

class LoadsViewController: UIViewController {

    @IBOutlet weak var loadTexting: UILabel!
    var loadmeText = ""
    @IBOutlet weak var loadLots: LottieAnimationView!
    override func viewDidLoad() {
        super.viewDidLoad()
        lottiePlay()

        loadTexting.text = loadmeText
//      dismissDelay()
        // Do any additional setup after loading the view.
    }


    
    func dismissDelay() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0) {  self.dismiss(animated: true)
        }
       
    }
    
    func lottiePlay() {
        
        // 1. Set animation content mode
          
          loadLots.contentMode = .scaleAspectFit
          
          // 2. Set animation loop mode
          
        loadLots.loopMode = .playOnce
          
          // 3. Adjust animation speed
          
        loadLots.animationSpeed = 1.0
          
          // 4. Play animation
        loadLots.play(completion: { _ in
            
            self.dismissDelay()
            
        })
        
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
