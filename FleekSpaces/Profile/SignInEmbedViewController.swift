//
//  SignInEmbedViewController.swift
//  FleekSpaces
//
//  Created by Mayur P on 12/07/22.
//

import UIKit
import SwiftUI

class SignInEmbedViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let controllers = UIHostingController(rootView: LoginView(didCompleteLoginProcess: {
            
        }))
//        controllers.modalPresentationStyle = .fullScreen
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
//        self.navigationController?.pushViewController(controllers, animated: true)
        controllers.modalPresentationStyle = .overCurrentContext
     present(controllers, animated: true)
        // Do any additional setup after loading the view.
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
