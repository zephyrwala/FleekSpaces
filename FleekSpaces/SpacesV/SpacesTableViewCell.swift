//
//  SpacesTableViewCell.swift
//  FleekSpaces
//
//  Created by Mayur P on 22/02/23.
//

import UIKit
import SDWebImage

class SpacesTableViewCell: UITableViewCell {

    @IBOutlet weak var cardBG: UIView!
    
    @IBOutlet weak var posterShadowCast: UIView!
    @IBOutlet weak var userActivityLabels: UILabel!
    @IBOutlet weak var platformIcon: UIImageView!
    @IBOutlet weak var userProfilePic: UIImageView!
    @IBOutlet weak var mainPoster: UIImageView!
    @IBOutlet weak var visBlur: UIVisualEffectView!
    @IBOutlet weak var bgPosterImage: UIImageView!
    @IBOutlet weak var baseBackground: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
        
        
    }

    
    func setupCell(fromData: SpacesFeedElement) {
   
        if let safename = fromData.user?.name {
            
            if let safeMovieName = fromData.title {
                
                self.userActivityLabels.text = "\(safename) liked \(safeMovieName)"
            }
           
        }
      
        if let postersURL = fromData.postersURL {
            
            let newURL = URL(string: "https://image.tmdb.org/t/p/w500\(postersURL)")
            self.mainPoster.sd_setImage(with: newURL)
            self.bgPosterImage.sd_setImage(with: newURL)
        }
            
        
       
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
