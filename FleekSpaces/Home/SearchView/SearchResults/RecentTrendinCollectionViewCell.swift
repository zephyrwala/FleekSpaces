//
//  RecentTrendinCollectionViewCell.swift
//  FleekSpaces
//
//  Created by Mayur P on 17/03/23.
//

import UIKit

class RecentTrendinCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var posterName: UILabel!
    @IBOutlet weak var posterView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        posterView.layer.cornerRadius = 9
    }

    
    func setupCell(fromData: Worldwide) {
        
        self.posterName.text = fromData.title
        posterView.layer.borderColor = UIColor.lightGray.cgColor
        posterView.layer.borderWidth = 1
        
        if let mainPosterPath = fromData.posterURL {
            
            let newURL = URL(string: "https://image.tmdb.org/t/p/w500/\(mainPosterPath)")
            self.posterView.sd_setImage(with: newURL)
        }
        
    }
}
