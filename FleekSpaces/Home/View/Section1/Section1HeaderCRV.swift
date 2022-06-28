//
//  Section1HeaderCRV.swift
//  FleekSpaces
//
//  Created by Mayur P on 01/06/22.
//

import UIKit

protocol seeAllTapped: class {
    
    func didTapSeeAllBtn(sender: UIButton)
    
}

class Section1HeaderCRV: UICollectionReusableView {

    var seeAllDelegate: seeAllTapped?
    @IBOutlet weak var addButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    @IBAction func addBtnAction(_ sender: UIButton) {
        let controller = ChooseSubsViewController()
        seeAllDelegate?.didTapSeeAllBtn(sender: sender)
        
    }
    
    
}
