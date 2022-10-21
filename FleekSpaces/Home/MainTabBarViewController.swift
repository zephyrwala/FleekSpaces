//
//  MainTabBarViewController.swift
//  FleekSpaces
//
//  Created by Mayur P on 21/10/22.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    @IBOutlet weak var myTabBar: UITabBar!
    override func viewDidLoad() {
        super.viewDidLoad()

//        setTabBarProfile()
        // Do any additional setup after loading the view.
    }
    
    
    func setTabBarProfile() {
        
        
             let myTabBarItem3 = (self.tabBar.items?[2])! as UITabBarItem
        myTabBarItem3.image = UIImage(named: "bene")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
             myTabBarItem3.selectedImage = UIImage(named: "bene")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
             myTabBarItem3.title = "Profile"
             myTabBarItem3.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
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
