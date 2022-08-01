//
//  MoviePlayCollectionViewCell.swift
//  FleekSpaces
//
//  Created by Mayur P on 10/06/22.
//

import UIKit

class MoviePlayCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var buyBtn: UIButton!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var subsName: UILabel!
    @IBOutlet weak var subsLogo: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setupBtns()
        // Initialization code
    }
    
    
    func setupStreaming(fromData: EpisodeFlatrate) {
        self.subsName.text = fromData.providerName
        
        if let pathWay = fromData.logoPath {
            
            let newURL = URL(string: "https://image.tmdb.org/t/p/w500\(pathWay)")
            self.subsLogo.sd_setImage(with: newURL)
            self.subsLogo.layer.cornerRadius = 12
        }
      
    }
    
    
    func setupCell(fromData: TextLogos) {
        
        self.subsLogo.image = fromData.posterImage
        self.subsName.text = fromData.postername
        self.subsLogo.layer.cornerRadius = 12
        
    }
    
    func setupBtns() {
        
//        self.playBtn.backgroundColor = .blue
        
    }

}
