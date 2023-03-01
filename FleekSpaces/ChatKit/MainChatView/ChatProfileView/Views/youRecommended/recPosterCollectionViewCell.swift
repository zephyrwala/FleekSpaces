//
//  recPosterCollectionViewCell.swift
//  FleekSpaces
//
//  Created by Mayur P on 27/02/23.
//

import UIKit
import SDWebImage

class recPosterCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var posterView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    
    func setupCell(fromdata: RecommendedList ) {
        
        if let posterUrl = fromdata.postersURL {
            
            let newURL = URL(string: "https://image.tmdb.org/t/p/w500\(posterUrl)")
            print("poster url is \(newURL)")
            self.posterView.sd_setImage(with: newURL)
            
            posterView.layer.cornerRadius = 16
        }
       
        
    }

}
