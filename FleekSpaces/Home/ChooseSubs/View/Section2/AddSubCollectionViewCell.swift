//
//  AddSubCollectionViewCell.swift
//  FleekSpaces
//
//  Created by Mayur P on 06/06/22.
//

import UIKit
//import CheckmarkCollectionViewCell

class AddSubCollectionViewCell: UICollectionView {
    @IBOutlet weak var subscriptionLogo: UIImageView!
    @IBOutlet weak var subscriptionName: UILabel!
    @IBOutlet weak var CardBgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func setupCell(fromData: TextLogos) {
        
        
        self.subscriptionLogo.image = fromData.posterImage
        self.subscriptionName.text = fromData.postername
        CardBgView.layer.cornerRadius = 15
        subscriptionLogo.makeItGolGol()
        
    }
    
//    override var isSelected: Bool {
//                didSet {
//                    if self.isSelected {
////                        bgVIew.backgroundColor = UIColor(named: "upurple")
//                        subscriptionLogo.image = UIImage(systemName: "checkmark.circle.fill")
//                        backgroundView?.layer.cornerRadius = 11
//                        subscriptionName.textColor = .white
//
//                    }
//                    else {
//                        subscriptionLogo.image = UIImage(systemName: "circle")
//                        subscriptionName.textColor = .gray
//
//                    }
//                }
//            }
    
    //cell selection logic ends here

}
