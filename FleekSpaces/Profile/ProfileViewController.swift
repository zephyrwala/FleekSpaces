//
//  ProfileViewController.swift
//  FleekSpaces
//
//  Created by Mayur P on 22/06/22.
//

import UIKit
import SDWebImage
//import FirebaseAuth

class ProfileViewController: UIViewController, DataEnteredDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var recommendBtn: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var watchlistBtn: UIButton!
    
    @IBOutlet weak var myProfileBg: UIImageView!
    
    var selectedOption = 0
    var recommendCount = [Int]()
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var changeProfile: UIButton!
    func userDidEnterInformation(info: String) {
        userNameLabel.text = "\(info)"
    }
    
    

   
    
    @IBOutlet weak var listCollectionView: UICollectionView!
    
    var chatUser: ChatUser?
    @IBAction func changeProfileBtn(_ sender: Any) {
       presentPhotoActionSheet()
        
    }
    @IBOutlet weak var segmentTabsSelection: UISegmentedControl!
    
    @IBOutlet weak var userNameLabel: UILabel!
    let defaults = UserDefaults.standard
    var names = "My Name"
    override func viewDidLoad() {
        super.viewDidLoad()
        checkSignIn()
       
        profileImage.makeItGolGol()
     
        fetchUserMovieData()
        fetchUserWatchlistData()
        setupButtons()

        changeProfile.setTitle("", for: .normal)
//        presentModal()
//       showSignUp()
       
            if let imageUrl = self.chatUser?.profileImageUrl {
                
                self.profileImage.sd_setImage(with: URL(string: imageUrl))
                self.myProfileBg.sd_setImage(with: URL(string: imageUrl))
            }
            
            self.self.userNameLabel.text = self.chatUser?.email
        
        print("Output is:")
        print(chatUser?.email)
        print(chatUser?.profileImageUrl)
//        getuserData()
        
        setupCollectionView()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        checkSignIn()
        profileImage.makeItGolGol()
     
        fetchUserMovieData()
        fetchUserWatchlistData()
        

        changeProfile.setTitle("", for: .normal)
//        presentModal()
//       showSignUp()
       
            if let imageUrl = self.chatUser?.profileImageUrl {
                
                self.profileImage.sd_setImage(with: URL(string: imageUrl))
                self.myProfileBg.sd_setImage(with: URL(string: imageUrl))
            }
            
            self.self.userNameLabel.text = self.chatUser?.email
        
        print("Output is:")
        print(chatUser?.email)
        print(chatUser?.profileImageUrl)
//        getuserData()
        
        setupCollectionView()
        setupButtons()
       
    }
    
    
    
    func setupButtons() {
        
        
        likeBtn.imageEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 10, right: 10)
        watchlistBtn.imageEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 10, right: 10)
        DispatchQueue.main.async {
            if let safeLike = FinalDataModel.userLikes?.count {
                
                self.watchlistBtn.setTitle("\(safeLike)+", for: .normal)
            }
            if let safeWatchlist = FinalDataModel.fetchWatchList?.count {
                
                self.likeBtn.setTitle("\(safeWatchlist)", for: .normal)
            }
        }
       
        
       
        
        
    }
    
    
    //MARK: - Setup CollectionView
    
    func setupCollectionView() {
        
        listCollectionView.delegate = self
        listCollectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical //.horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        listCollectionView.setCollectionViewLayout(layout, animated: true)
        
        listCollectionView.register(UINib(nibName: "UserDataCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "userData")

        
        
        
        
    }
    
    
    //MARK: - Fetch Current user
    func fetchCurrentUser() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            self.displayUIAlert(yourMessage: "You need to login to access your profile!")
            print("COuld not find firebase uid")
            return
        }
        
        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                self.displayUIAlert(yourMessage: "Failed to fetch current user: \(error)")
                
                print("Failed to fetch current user:", error)
                return
            }
            
            self.chatUser = try? snapshot?.data(as: ChatUser.self)
            print("chat user data is \(self.chatUser)")
            FirebaseManager.shared.currentUser = self.chatUser
            print("chat user singleton data is \(self.chatUser)")
            
            guard let imageURL = self.chatUser?.profileImageUrl else {return}
            let userName = self.chatUser?.email.components(separatedBy: "@").first ?? "loading..."
            
            DispatchQueue.main.async {
                
                self.userNameLabel.text = userName
                self.profileImage.sd_setImage(with: URL(string: imageURL))
                self.myProfileBg.sd_setImage(with: URL(string: imageURL))
            }
        }
    }
    
    
    
    
    
    //MARK: - Apply username and profile pic
    
    func getuserData() {
        
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            return
        }
        

       
        
    }
    
    //MARK: - Fetch watchlist
    
    
    func fetchUserWatchlistData() {
        
        let network = NetworkURL()
        
        guard let myUrl = URL(string: "https://api-space-dev.getfleek.app/activity/get_user_watch_list/") else {return}
                
        guard let myTOken = defaults.string(forKey: "userToken") else {return}
    
        network.tokenCalls([FetchWatchList].self, url: myUrl, token: myTOken, methodType: "GET") { myResult, yourMessage in
            
            
            switch myResult {
                
                
            case .success(let userData):
                FinalDataModel.fetchWatchList = userData
                DispatchQueue.main.async {
                    
                   
                        
                    self.watchlistBtn.setTitle("\(userData.count)", for: .normal)
                    
                    
                    self.listCollectionView.reloadData()
                }
                for users in userData {
                    print("Movie liked are \(users.title)")
                    
                }
            case .failure(let err):
                print("Error is \(err)")
                
                
            }
        }
    }
    
    
    //MARK: - Fetch user data
    
    
    func fetchUserMovieData() {
        
        let network = NetworkURL()
        
        guard let myUrl = URL(string: "https://api-space-dev.getfleek.app/activity/get_likes_dislikes_of_user/") else {return}
                
        guard let myTOken = defaults.string(forKey: "userToken") else {return}
    
        network.tokenCalls([UserLike].self, url: myUrl, token: myTOken, methodType: "GET") { myResult, yourMessage in
            
            
            switch myResult {
                
                
            case .success(let userData):
                FinalDataModel.userLikes = userData
                DispatchQueue.main.async {
                    
                    self.likeBtn.setTitle("\(userData.count)", for: .normal)
                    self.listCollectionView.reloadData()
                }
                for users in userData {
                    print("Movie liked are \(users.title)")
                    
                }
            case .failure(let err):
                print("Error is \(err)")
                
                
            }
        }
    }
    
    //MARK: - Download Image
    
    func downloadImage(imageView: UIImageView, url: URL) {
        
        URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
            guard let data = data, error == nil else {
                print("No Image data")
                return
            }
            DispatchQueue.main.async {
                print(data)
                print("image found")
                let image = UIImage(data: data)
                self.profileImage.image = image
            }
        }).resume()
            
          
        }

    
    //MARK: - Login Prompt
    
    func loginPrompt() {
        
        let actionSheet = UIAlertController(title: "Auth Status 🤔", message: "Hey Bro! You must login to view this section!", preferredStyle: .alert)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        
        //TODO: - On Cancel try to push to another view
        
        actionSheet.addAction(UIAlertAction(title: "Log In", style: .default, handler: { [weak self] _ in
            
           
        
            
            let controller = LoginVC()
                
              
            self?.navigationController?.pushViewController(controller, animated: true)
//            self?.present(controller, animated: true)
            
          
            
        }))
        
        
       
        
       
        
    
        
        present(actionSheet, animated: true)
        
        
    }
    
    
    
    //MARK: - validate login
    
 
    
    func showSignUp() {
        
        let controller = LoginEmailViewController()
//        self.navigationController?.pushViewController(controller, animated: true)
//        controller.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    func setupUserName() {
        
        if let firstName = defaults.string(forKey: "firstName") {
            
            print("This is on")
            let lastName = defaults.string(forKey: "lastName")
            
            self.userNameLabel.text = "Hey \(firstName) \(lastName) Bro!"
        }
       
    }
    
    @IBAction func segmentTap(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
            
        case 0:
            print("Watchlist selected")
            selectedOption = 0
            fetchUserWatchlistData()
            DispatchQueue.main.async {
                self.segmentTabsSelection.selectedSegmentTintColor = .systemOrange
                self.watchlistBtn.tintColor = .systemYellow
                self.likeBtn.tintColor = .darkGray
            }
           
            
            
        case 1:
            print("Likes selected")
            selectedOption = 1
            fetchUserMovieData()
            self.watchlistBtn.tintColor = .darkGray
            self.likeBtn.tintColor = .systemTeal
            segmentTabsSelection.selectedSegmentTintColor = .systemTeal
            
        case 2:
            selectedOption = 2
            emptyData()
            self.watchlistBtn.tintColor = .darkGray
            self.likeBtn.tintColor = .darkGray
            segmentTabsSelection.selectedSegmentTintColor = .darkGray
            print("Recommended selected")
            
        default:
            print("Default")
        }
      
//        let loginState = LoginVC()
//
//        if let sheet = loginState.sheetPresentationController {
//            sheet.detents = [ .large() ]
//        }
//
//        present(loginState, animated: true)
//        presentModal()
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

    func emptyData() {
        
      
        DispatchQueue.main.async {
                        FinalDataModel.userLikes?.removeAll()
                        self.listCollectionView.reloadData()
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
        
        
        actionSheet.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { [weak self] _ in
            
            
            try? FirebaseManager.shared.auth.signOut()
            NotificationCenter.default.post(name: NSNotification.Name("dismissSwiftUI"), object: nil)
           let controller = LoginVC()
            self?.navigationController?.pushViewController(controller, animated: true)
           
            
        }))
        
        present(actionSheet, animated: true)
        
        
    }
    
    //MARK: - Sign In Check
    func checkSignIn() {
        
        if  FirebaseManager.shared.auth.currentUser == nil {
           loginPrompt()
        } else {
            self.displayUIAlert(yourMessage: "Welcome back bro!")
            fetchCurrentUser()
        }
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


extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch selectedOption {
            
        case 0:
           return FinalDataModel.fetchWatchList?.count ?? 0
            
        case 1:
           return FinalDataModel.userLikes?.count ?? 0
            
        case 2:
            return recommendCount.count ?? 0
            
        default:
           return 1
            
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let lay = collectionViewLayout as! UICollectionViewFlowLayout
        let widthPerItem = collectionView.frame.width / 3 - lay.minimumInteritemSpacing
        
        return CGSize(width:widthPerItem, height:175)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userData", for: indexPath) as! UserDataCollectionViewCell
        
        
        
        switch selectedOption {
            
            
        case 0:
            if let posterURL = FinalDataModel.fetchWatchList?[indexPath.item].postersURL {
                
                let newURL = URL(string: "https://image.tmdb.org/t/p/w500/\(posterURL)")
                cell.posterImage.layer.cornerRadius = 6
                cell.posterImage.sd_setImage(with: newURL)
                
                
            }
            
            return cell
            
        case 1:
            
            if let posterURL = FinalDataModel.userLikes?[indexPath.item].postersURL {
                
                let newURL = URL(string: "https://image.tmdb.org/t/p/w500/\(posterURL)")
                cell.posterImage.layer.cornerRadius = 6
                cell.posterImage.sd_setImage(with: newURL)
                
                
            }
            
            return cell
            
        case 2:
            if let posterURL = FinalDataModel.userLikes?[indexPath.item].postersURL {
                
                let newURL = URL(string: "https://image.tmdb.org/t/p/w500/\(posterURL)")
                cell.posterImage.layer.cornerRadius = 6
                cell.posterImage.sd_setImage(with: newURL)
                
                
            }
            
            return cell
            
            
            
        default:
            
            if let posterURL = FinalDataModel.userLikes?[indexPath.item].postersURL {
                
                let newURL = URL(string: "https://image.tmdb.orgg/t/p/w500/\(posterURL)")
                cell.posterImage.layer.cornerRadius = 6
                cell.posterImage.sd_setImage(with: newURL)
                
                
            }
            
            return cell
            
            
        }
        
        //
    }
    
    
    
}
