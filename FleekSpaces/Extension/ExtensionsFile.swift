//
//  ExtensionsFile.swift
//  FleekSpaces
//
//  Created by Mayur P on 01/06/22.
//

import Foundation
import UIKit


extension UIViewController {
    
    func displayUIAlert(yourMessage: String) {
        
        var dialogMessage = UIAlertController(title: "Console log 📝", message: yourMessage, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
        
    }
    
}


extension UIImageView {
    
    func makeItGolGol() {

//        layer.borderWidth = 1
        layer.masksToBounds = true
        layer.borderColor = UIColor.systemGray.cgColor
        
        layer.cornerRadius = frame.height/2 //This will change with corners of image and height/2 will make this circle shape
        clipsToBounds = true
    }
}
