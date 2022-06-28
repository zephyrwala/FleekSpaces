//
//  ProfileViewController.swift
//  FleekSpaces
//
//  Created by Mayur P on 22/06/22.
//

import UIKit

class ProfileViewController: UIViewController, DataEnteredDelegate, UINavigationControllerDelegate {
    
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var changeProfile: UIButton!
    func userDidEnterInformation(info: String) {
        userNameLabel.text = "\(info)"
    }
    
    
    
    
    
    @IBAction func changeProfileBtn(_ sender: Any) {
       presentPhotoActionSheet()
    }
    @IBOutlet weak var segmentTabsSelection: UISegmentedControl!
    
    @IBOutlet weak var userNameLabel: UILabel!
    let defaults = UserDefaults.standard
    var names = "My Name"
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage.makeItGolGol()
        
        
//        segmentTabsSelection.removeBorder()
////        segmentTabsSelection.addUnderlineForSelectedSegment()
//        segmentTabsSelection.removeBorder()
//        segmentTabsSelection.setupSegment()
//        segmentTabsSelection.backgroundColor = .clear
//
      
        // Do any additional setup after loading the view.
        
//        let controller = SignInViewController()
//               // Present the bottom sheet
//               present(controller, animated: true, completion: nil)
//        setupUserName()
        changeProfile.setTitle("", for: .normal)
//        presentModal()
        showSignUp()
        print(names)
    }
    
    func showSignUp() {
        
        let controller = LoginEmailViewController()
//        self.navigationController?.pushViewController(controller, animated: true)
        controller.modalPresentationStyle = .fullScreen
        self.present(controller, animated: true)
        
        
    }
    
    func setupUserName() {
        
        if let firstName = defaults.string(forKey: "firstName") {
            
            print("This is on")
            let lastName = defaults.string(forKey: "lastName")
            
            self.userNameLabel.text = "Hey \(firstName) \(lastName) Bro!"
        }
       
    }
    
    @IBAction func segmentTap(_ sender: Any) {
        
        presentModal()
    }
    
    private func presentModal() {
        let detailViewController = SignInViewController()
        let nav = UINavigationController(rootViewController: detailViewController)
        detailViewController.delegate = self
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

    @IBAction func segmentTaps(_ sender: Any) {
//        segmentTabsSelection.changeUnderlinePosition()
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
extension ProfileViewController: UIImagePickerControllerDelegate {
    
    
    func presentPhotoActionSheet() {
        
        let actionSheet = UIAlertController(title: "Profile Picture", message: "How would you like to select a picture?", preferredStyle: .actionSheet)
        
        //3 buttons - cancel , take ,choose
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { [weak self] _ in
            
            self?.presentCamera()
            
        }))
        
        
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { [weak self] _ in
            
            self?.presentPhotoPicker()
            
        }))
        
        present(actionSheet, animated: true)
        
        
    }
    
    //MARK: - show camera
    
    func presentCamera() {
        
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
        
        
    }
    //MARK: - show photo picker
    
    func presentPhotoPicker() {
        
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
        
        
        
    }
    
    //MARK: - Camera and Photo picker functions
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
       
        
       
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
   
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {return}
        
        self.profileImage.image = selectedImage
       
    
    }
    
}

extension UISegmentedControl {

    func removeBorder(){

        self.tintColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        self.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor : UIColor.darkGray], for: .selected)
        self.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor : UIColor.gray], for: .normal)
        if #available(iOS 13.0, *) {
            self.selectedSegmentTintColor = UIColor.clear
        }

    }

    func setupSegment() {
        self.removeBorder()
        let segmentUnderlineWidth: CGFloat = self.bounds.width
        let segmentUnderlineHeight: CGFloat = 2.0
        let segmentUnderlineXPosition = self.bounds.minX
        let segmentUnderLineYPosition = self.bounds.size.height - 1.0
        let segmentUnderlineFrame = CGRect(x: segmentUnderlineXPosition, y: segmentUnderLineYPosition, width: segmentUnderlineWidth, height: segmentUnderlineHeight)
        let segmentUnderline = UIView(frame: segmentUnderlineFrame)
        segmentUnderline.backgroundColor = UIColor.clear

        self.addSubview(segmentUnderline)
        self.addUnderlineForSelectedSegment()
    }

    func addUnderlineForSelectedSegment(){

        let underlineWidth: CGFloat = self.bounds.size.width / CGFloat(self.numberOfSegments)
        let underlineHeight: CGFloat = 2.0
        let underlineXPosition = CGFloat(selectedSegmentIndex * Int(underlineWidth))
        let underLineYPosition = self.bounds.size.height - 1.0
        let underlineFrame = CGRect(x: underlineXPosition, y: underLineYPosition, width: underlineWidth, height: underlineHeight)
        let underline = UIView(frame: underlineFrame)
        underline.backgroundColor = UIColor.darkGray
        underline.tag = 1
        self.addSubview(underline)


    }

    func changeUnderlinePosition(){
        guard let underline = self.viewWithTag(1) else {return}
        let underlineFinalXPosition = (self.bounds.width / CGFloat(self.numberOfSegments)) * CGFloat(selectedSegmentIndex)
        underline.frame.origin.x = underlineFinalXPosition

    }
}
