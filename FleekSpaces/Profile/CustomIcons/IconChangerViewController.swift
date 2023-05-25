//
//  IconChangerViewController.swift
//  FleekSpaces
//
//  Created by Mayur P on 20/10/22.
//

import UIKit
import Lottie

class IconChangerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var dismissBtn: UIImageView!
    @IBOutlet weak var lottieViewAnimation: LottieAnimationView!
    
    var iconSelected = false
    
    var defaults = UserDefaults.standard
    
    @IBOutlet weak var dismaBtn: UIButton!
    
    
    @IBOutlet weak var mainIconImage: UIImageView!
    
    @IBOutlet weak var iconTableView: UITableView!
    
    var iconSet = [
                    AltIcons(iconImage: "xmas0", iconName: "Ho Ho Ho!"),
                    AltIcons(iconImage: "xmas1", iconName: "Jingle Bells"),
                    AltIcons(iconImage: "xmas2", iconName: "Merry Xmas"),
                    AltIcons(iconImage: "Diwali9", iconName: "Diwali Diyas"),
                    AltIcons(iconImage: "Diwali6", iconName: "Diwali Lights"),
                   AltIcons(iconImage: "Diwali3", iconName: "Fireworks"),
                   AltIcons(iconImage: "Diwali5", iconName: "More Fireworks"),
                  
                   AltIcons(iconImage: "Diwali7", iconName: "Diwali Rangoli"),
                   AltIcons(iconImage: "Diwali8", iconName: "Diwali Daze"),
                 
                   AltIcons(iconImage: "Diwali", iconName: "Diwali Lantern"),
                   AltIcons(iconImage: "Diwali2", iconName: "Diwali Diya"),
                    AltIcons(iconImage: "default", iconName: "Default")
                  
    
    
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let iconName = defaults.string(forKey: "selectedIcon") {
            
            mainIconImage.image = UIImage(named: iconName)
        }
        setupTableView()
        // Do any additional setup after loading the view.
   
    }
    
    @IBAction func dismaBtnTap(_ sender: Any) {
        
        self.dismiss(animated: true)
    }
    
    
    func lottiePlay() {
        
        // 1. Set animation content mode
          
          lottieViewAnimation.contentMode = .scaleAspectFit
          
          // 2. Set animation loop mode
          
        lottieViewAnimation.loopMode = .playOnce
          
          // 3. Adjust animation speed
          
        lottieViewAnimation.animationSpeed = 0.5
          
          // 4. Play animation
        lottieViewAnimation.play(completion: { _ in
            
            self.lottieViewAnimation.isHidden = true
            
        })
        
    }

    func setupTableView() {
        
//        iconTableView.allowsMultipleSelection = true
        iconTableView.delegate = self
        iconTableView.dataSource = self
        iconTableView.register(UINib(nibName: "iconTableViewCell", bundle: nil), forCellReuseIdentifier: "icono")
        mainIconImage.layer.cornerRadius = 20
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        iconSet.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        
        print("\(iconSet[indexPath.row].iconImage)")
        
        guard let safeIconName = iconSet[indexPath.row].iconImage else {
            return
        }
        
        self.mainIconImage.image = UIImage(named: "\(safeIconName)")
        print("Icon selected \(safeIconName)")
        defaults.set(safeIconName, forKey: "selectedIcon")
        DispatchQueue.main.async {
            UIApplication.shared.setAlternateIconName(safeIconName) { error in
                
                guard error == nil else {
                    return
                }
                self.lottieViewAnimation.isHidden = false
               
                self.lottiePlay()
               
            }
        }
      
//        <key>CFBundleIcons</key>
//        <dict>
//            <key>CFBundlePrimaryIcon</key>
//            <dict>
//                <key>CFBundleIconFiles</key>
//                <array>
//                    <string>Icon-1</string>
//                </array>
//                <key>UIPrerenderedIcon</key>
//                <false/>
//            </dict>
//            <key>CFBundleAlternateIcons</key>
//            <dict>
//                <key>AppIcon-2</key>
//                <dict>
//                    <key>CFBundleIconFiles</key>
//                    <array>
//                        <string>Icon-2</string>
//                    </array>
//                    <key>UIPrerenderedIcon</key>
//                    <false/>
//                </dict>
//                <key>AppIcon-3</key>
//                <dict>
//                    <key>CFBundleIconFiles</key>
//                    <array>
//                        <string>Icon-3</string>
//                    </array>
//                    <key>UIPrerenderedIcon</key>
//                    <false/>
//                </dict>
//            </dict>
//        </dict>
//        
        
        
       
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "icono", for: indexPath) as! iconTableViewCell
        if let safeImagePath = iconSet[indexPath.row].iconImage {
            
            cell.iconImage.image = UIImage(named: "\(safeImagePath)")
        }
       
        if let safeIconName = iconSet[indexPath.row].iconName {
            
            cell.iconName.text = "\(safeIconName)"
        }
       
        
        cell.iconImage.layer.cornerRadius = 10
    
    
        
        
        return cell
    }
    
    

}



struct AltIcons {
    
    let iconImage: String?
    let iconName: String?
    
    
}

