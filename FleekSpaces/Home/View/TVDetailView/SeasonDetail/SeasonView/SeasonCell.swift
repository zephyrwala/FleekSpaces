//
//  SeasonCell.swift
//  FleekSpaces
//
//  Created by Mayur P on 21/06/22.
//

import UIKit

class SeasonCell: UICollectionViewCell {

    @IBOutlet weak var btnView: UIView!
    @IBOutlet weak var seasonBtn: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func setupCell(fromData: SeasonNumbers) {
        
        self.seasonBtn.text = fromData.seasons
        btnView.layer.cornerRadius = 18
        btnView.layer.borderWidth = 1
        btnView.layer.borderColor = UIColor.gray.cgColor
        btnView.backgroundColor = UIColor(named: "BGColor")
    }
    
    func setupSelectedCell() {
        
        btnView.layer.cornerRadius = 18
        btnView.layer.borderWidth = 1
//        btnView.layer.borderColor = UIColor.gray.cgColor
        btnView.backgroundColor = UIColor(named: "BtnGreenColor")
    }
    
    
    override var isSelected: Bool {
         didSet {
             if self.isSelected {
                 btnView.backgroundColor = UIColor(named: "BtnGreenColor")
             } else {
                 btnView.layer.borderWidth = 1
                 btnView.layer.borderColor = UIColor.gray.cgColor
                 btnView.backgroundColor = UIColor(named: "BGColor")
             }
         }
     }

}
