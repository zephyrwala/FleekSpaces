//
//  GenreCollectionViewCell.swift
//  FleekSpaces
//
//  Created by Mayur P on 15/06/22.
//

import UIKit

class GenreCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var genreNames: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupCell(fromData: MovieGenres) {
        
        self.genreNames.text = fromData.genreName
        
    }
}
