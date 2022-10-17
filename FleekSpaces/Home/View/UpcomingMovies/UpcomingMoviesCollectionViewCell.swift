//
//  UpcomingMoviesCollectionViewCell.swift
//  FleekSpaces
//
//  Created by Mayur P on 17/10/22.
//

import UIKit

class UpcomingMoviesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var posterImage: UIImageView!
    
    @IBOutlet weak var releaseDate: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func setupCell(fromData: Movies){
        
        if let mainPosterPath = fromData.posterPath {
            
            let newURL = URL(string: "https://image.tmdb.org/t/p/w500/\(mainPosterPath)")
            self.posterImage.sd_setImage(with: newURL)
        }
       
        
        posterImage.layer.cornerRadius = 16
        
        releaseDate.text = fromData.releaseDate

        guard let safeDate = fromData.releaseDate else {return}
        dateFormato(myString: safeDate)
    }
    
    
    func dateFormato(myString: String) {
        
        // Create String
        let string = myString

        // Create Date Formatter
        let dateFormatter = DateFormatter()

        // Set Date Format
        dateFormatter.dateFormat = "yy-MM-dd"

        guard let myDate = dateFormatter.date(from: string) else {
                return
            }
        // Convert String to Date
        print("DATE IS HERE")
        print("\(dateFormatter.date(from: string))")
        
        
        dateFormatter.dateFormat = "MMMM"
            let day = dateFormatter.string(from: myDate)
        
        dateFormatter.dateFormat = "dd"
            let currentDate = dateFormatter.string(from: myDate)
        
        
        print("This is the day \(day) and \(currentDate)")
        
        
        self.releaseDate.text = "\(day) \(currentDate)"
        
    }
    
    
    
}
