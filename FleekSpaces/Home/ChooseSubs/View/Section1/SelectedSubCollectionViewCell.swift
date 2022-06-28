//
//  SelectedSubCollectionViewCell.swift
//  FleekSpaces
//
//  Created by Mayur P on 02/06/22.
//

import UIKit

class SelectedSubCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var subBtn: UIButton!
    @IBOutlet weak var subImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func setupCell(fromData: Logos) {
        
        self.subImage.image = fromData.posterImage
        subImage.layer.cornerRadius = 30
        
        
    }
    
    @IBAction func deleteSubBtnTap(_ sender: Any) {
    }
    

}
