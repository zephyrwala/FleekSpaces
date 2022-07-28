//
//  Section1CollectionViewCell.swift
//  FleekSpaces
//
//  Created by Mayur P on 01/06/22.
//

import UIKit
import SDWebImage

class Section1CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var selectedSub: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
       
    }

   
    //MARK: - Setup cell with new api data
    func setupStreamCells(fromData: StreamingElement) {
        
        if let imageURL = fromData.iconURL {
            
            self.selectedSub.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/original\(imageURL)"))
            
        }
       
//        selectedSub.makeItGolGol()
     
        selectedSub.layer.cornerRadius = selectedSub.frame.size.width / 2
        selectedSub.clipsToBounds = true

        selectedSub.layer.borderWidth = 1
        selectedSub.layer.borderColor = UIColor(named: "BtnGreenColor")?.cgColor
        
        
    }
  
    
    func setupCell(fromData: Results){
        
        //https://image.tmdb.org/t/p/original/
        let newURL = URL(string: "https://image.tmdb.org/t/p/original/\(fromData.posterPath!)")
        self.selectedSub.sd_setImage(with: newURL)
        
//        selectedSub.layer.cornerRadius = 10
//        selectedSub.layer.borderWidth = 20
//        selectedSub.clipsToBounds = true
//        selectedSub.layer.borderColor = UIColor.systemGray.cgColor
//        selectedSub.makeItGolGol()
//        self.titleCard.roundCorners(corners: [.bottomLeft, .bottomRight], radius: 10)
//        makeRounded()
        selectedSub.makeItGolGol()
        
    }
    
    func setupLogos(fromData: Logos) {
        
        self.selectedSub.image = fromData.posterImage
//        selectedSub.layer.cornerRadius = 10
//        selectedSub.makeItGolGol()
        selectedSub.makeItGolGol()
        
    }
    
    func makeRounded() {

        selectedSub.layer.borderWidth = 1
        selectedSub.layer.masksToBounds = false
        selectedSub.layer.borderColor = UIColor.systemGray.cgColor
        selectedSub.layer.cornerRadius = selectedSub.frame.height/2 //This will change with corners of image and height/2 will make this circle shape
        selectedSub.clipsToBounds = true
  }
    
}
