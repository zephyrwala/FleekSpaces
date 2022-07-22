//
//  ActorBioCVC.swift
//  FleekSpaces
//
//  Created by Mayur P on 14/06/22.
//

import UIKit

class ActorBioCVC: UICollectionViewCell {
    @IBOutlet weak var celebImage: UIImageView!
    @IBOutlet weak var celebName: UILabel!
    @IBOutlet weak var celebProfession: UILabel!
    @IBOutlet weak var celebBirthplace: UILabel!
    @IBOutlet weak var celebBirthday: UILabel!
    @IBOutlet weak var celebBio: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        celebImage.makeItGolGol()
    }
    
    func setupTVEpisodeCell(fromData: Crew) {
        
        self.celebName.text = fromData.name
        if let backdropURL = fromData.profilePath {
            let newURL = URL(string: "https://image.tmdb.org/t/p/w500\(backdropURL)")
            self.celebImage.sd_setImage(with: newURL)
           
        }
        
    }
    
    
    func setupActorCell(fromData: ActorDetails){
        
        self.celebName.text = fromData.fullName
        self.celebBio.text = fromData.bio
        if let birthday = fromData.birthDay {
            self.celebBirthday.text = "Date of Birth: \(birthday)"
        }
        if let birthplace = fromData.placeOfBirth {
            self.celebBirthplace.text = "Place of Birth: \(birthplace)"
        }
       
        if let backdropURL = fromData.posterUrls?[0] {
            let newURL = URL(string: "https://image.tmdb.org/t/p/w500\(backdropURL)")
            print("poster is \(newURL)")
            self.celebImage.sd_setImage(with: newURL)
            
           
        }
    }

}
