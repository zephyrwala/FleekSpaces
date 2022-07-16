//
//  BookCollectionViewCell.swift
//  FleekSpaces
//
//  Created by Mayur P on 15/07/22.
//

import UIKit

class BookCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var bookImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setupCell(fromData: Logos){
        
        self.bookImage.image = fromData.posterImage
        self.bookImage.layer.cornerRadius = 3
        
    }

}
