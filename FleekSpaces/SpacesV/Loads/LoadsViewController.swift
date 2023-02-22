//
//  LoadsViewController.swift
//  FleekSpaces
//
//  Created by Mayur P on 22/02/23.
//

import UIKit

class LoadsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

      dismissDelay()
        // Do any additional setup after loading the view.
    }


    
    func dismissDelay() {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {  self.dismiss(animated: true)
        }
       
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
