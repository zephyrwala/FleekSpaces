//
//  ChatViewController.swift
//  FleekSpaces
//
//  Created by Mayur P on 06/06/22.
//

import UIKit

class ChatViewController: UIViewController {

  
    @IBOutlet weak var bannerBgView: UIView!
    @IBOutlet weak var bannerImage: UIImageView!
    
    @IBOutlet weak var addChatBtn: UIButton!
    @IBOutlet weak var inviteBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        btnSetup()
      
//        presentModal()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func chatBtnTap(_ sender: Any) {
        
        self.displayUIAlert(yourMessage: "Chat Module will be coming soon!")
    }
    
    
    func btnSetup() {
        inviteBtn.layer.cornerRadius = 8
        addChatBtn.layer.borderWidth = 1
        addChatBtn.layer.masksToBounds = true
        addChatBtn.layer.borderColor = UIColor.systemGray.cgColor
         
        addChatBtn.layer.cornerRadius = addChatBtn.frame.height/2 //This will change with corners of image and height/2 will make this circle shape
        addChatBtn.clipsToBounds = true
        
    }

    @IBAction func inviteFriendstap(_ sender: Any) {
        
        let shareText = "👋🏻 Hey Bro! I'm inviting you to chat 💬 with me on Fleek Spaces 🍿 on https://getfleek.app/"
        let textShare = [shareText]
        let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view
            self.present(activityViewController, animated: true, completion: nil)
    }
    
    private func presentModal() {
        let detailViewController = SignInViewController()
        let nav = UINavigationController(rootViewController: detailViewController)
        // 1
        nav.modalPresentationStyle = .pageSheet

        
        // 2
        if let sheet = nav.sheetPresentationController {

            // 3
            sheet.detents = [.medium(), .large()]

        }
        // 4
        present(nav, animated: true, completion: nil)

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
