//
//  SpacesTableViewCell.swift
//  FleekSpaces
//
//  Created by Mayur P on 22/02/23.
//

import UIKit
import SDWebImage
import Lottie



//likes del
protocol PassLikesData: AnyObject {
    
    func spacesLikeBtnTap(_ cell: SpacesTableViewCell)
    
}


//follow btn del
protocol FollowBtnTap: AnyObject {
    func followBtnTap(sender: UIButton, cell: SpacesTableViewCell)
}


//watchlist del
protocol WatchlistBtnTap: AnyObject {
    
    func watchlistBtnTap (sender: UIButton, cell: SpacesTableViewCell)
}

class SpacesTableViewCell: UITableViewCell {

    
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var datesTime: UILabel!
    @IBOutlet weak var likeAnim: LottieAnimationView!
    @IBOutlet weak var cardBG: UIView!
    var likeBtnDelegate: PassLikesData?
    var followBtnDelegate: FollowBtnTap?
    var watchlistbtnDelegate: WatchlistBtnTap?
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var posterShadowCast: UIView!
    @IBOutlet weak var userActivityLabels: UILabel!
    @IBOutlet weak var platformIcon: UIImageView!
    @IBOutlet weak var userProfilePic: UIImageView!
    @IBOutlet weak var mainPoster: UIImageView!
    @IBOutlet weak var visBlur: UIVisualEffectView!
    @IBOutlet weak var bgPosterImage: UIImageView!
    @IBOutlet weak var baseBackground: UIView!
    @IBOutlet weak var watchlistBtn: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        likeAnim.isHidden = true
        mainPoster.layer.cornerRadius = 9
        mainPoster.layer.cornerCurve = .continuous
        cardBG.layer.cornerRadius = 15
        cardBG.layer.cornerCurve = .continuous
        bgPosterImage.layer.cornerRadius = 15
        bgPosterImage.layer.cornerCurve = .continuous
        visBlur.layer.cornerRadius = 15
        visBlur.clipsToBounds = true
        visBlur.layer.cornerCurve = .continuous
        userProfilePic.makeItGolGol()
        platformIcon.makeItGolGol()
        
        
        posterShadowCast.layer.shadowColor = UIColor.black.cgColor
        posterShadowCast.layer.shadowOpacity = 0.6
        posterShadowCast.layer.shadowOffset = .zero
        posterShadowCast.layer.shadowRadius = 10
        
        platformIcon.layer.borderWidth = 1
        platformIcon.layer.borderColor = UIColor.black.cgColor
        
        
    }

    
    //follow btn tap
    @IBAction func followBtnTap(_ sender: UIButton) {
        
        followBtnDelegate?.followBtnTap(sender: sender, cell: self)
    }
    
    
    
    //watchlist btn tap
    @IBAction func watchlistBtnTapped(_ sender: UIButton) {
        
        watchlistbtnDelegate?.watchlistBtnTap(sender: sender, cell: self)

    }
    
    
    
    //like btn tapped
    @IBAction func likeBtnTapped(_ sender: UIButton) {
        
        likeBtnDelegate?.spacesLikeBtnTap(self)
        lottiePlay()
        
    }
    
    
    
    
    
    
    //setup cell
    func setupCell(fromData: SpacesFeedElement) {
   
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: fromData.createdAt ?? "")
        print("dateso: \(date)")
        dateFormatter.dateFormat = "MMM d, h:mm a"
        let dayOfTheWeekString = dateFormatter.string(from: date!)
        
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "checkmark.circle")

        if let safeCount = fromData.totalLikeCount {
            if safeCount != 0 {
                self.likeBtn.setTitle("\(safeCount)", for: .normal)
            }
            
        }
        
        if let safeLikes = fromData.isLikedByMe {
           if safeLikes == true {
               self.likeBtn.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
           } else {
               self.likeBtn.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
               
           }
        }
        
        
        if let safeWatchCount = fromData.totalWatchlistCount {
            if safeWatchCount != 0 {
                self.watchlistBtn.setTitle("\(safeWatchCount)", for: .normal)
            }
        }
        
        if let safeWatch = fromData.isWatchlistedByMe {
            
            if safeWatch == true {
                self.watchlistBtn.setImage(UIImage(systemName: "video.fill.badge.checkmark"), for: .normal)
            } else {
                self.watchlistBtn.setImage(UIImage(systemName: "video.badge.plus"), for: .normal)
            }
            
        }
        // If you want to enable Color in the SF Symbols.
       

        if let pathWay = fromData.ottDetails?.ottDetailsIN?.flatrate?[0].logoPath {
            
            let newURL = URL(string: "https://image.tmdb.org/t/p/w500\(pathWay)")
            self.platformIcon.sd_setImage(with: newURL)
//            self.platformIcon.layer
//           self.plat self.subsLogo.layer.cornerRadius = 12
        }
       
        if let isFollowing = fromData.user?.following {
            if fromData.user?.following == true {
                self.followBtn.isHidden = true
            } else {
                self.followBtn.isHidden = false
            }
            
        }
        
        print("Date is \(dayOfTheWeekString)")
        
        self.datesTime.text = dayOfTheWeekString
        
        
        
        if let safename = fromData.user?.name {
            
            if let safeMovieName = fromData.title {
                if fromData.isWatchlist == false {
                    
                  
                    
                    self.userActivityLabels.text = "\(safename) liked \(safeMovieName)"
                } else {
                    
                    self.userActivityLabels.text = "\(safename) watchlisted \(safeMovieName)"
                    
                }
               
            }
           
        }
      
        if let postersURL = fromData.postersURL {
            
            let newURL = URL(string: "https://image.tmdb.org/t/p/w500\(postersURL)")
            self.mainPoster.sd_setImage(with: newURL)
            self.bgPosterImage.sd_setImage(with: newURL)
        }
        
        if let safeUserProfilePic = fromData.user?.avatarURL {
            print("user profile pic = \(safeUserProfilePic)")
            let newURL = URL(string: safeUserProfilePic)
            self.userProfilePic.sd_setImage(with: newURL, placeholderImage: UIImage(systemName: "person.circle"))
            
        }
            
        
       
        
    }
    
    
    
    
    
    //lottie play
    func lottiePlay() {
        
        self.likeBtn.alpha = 0
        self.likeAnim.isHidden = false
        // 1. Set animation content mode
          
        likeAnim.contentMode = .scaleAspectFit
          
          // 2. Set animation loop mode
          
        likeAnim.loopMode = .playOnce
          
          // 3. Adjust animation speed
          
        likeAnim.animationSpeed = 1.0
          
          // 4. Play animation
        likeAnim.play(completion: { _ in
            
             self.likeAnim.isHidden = true
            self.likeBtn.alpha = 1
            
        })
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
