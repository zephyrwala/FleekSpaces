//
//  SpacesTableViewCell.swift
//  FleekSpaces
//
//  Created by Mayur P on 22/02/23.
//

import UIKit

class SpacesTableViewCell: UITableViewCell {

    @IBOutlet weak var cardBG: UIView!
    
    @IBOutlet weak var mainPoster: UIImageView!
    @IBOutlet weak var visBlur: UIVisualEffectView!
    @IBOutlet weak var bgPosterImage: UIImageView!
    @IBOutlet weak var baseBackground: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mainPoster.layer.cornerRadius = 9
        mainPoster.layer.cornerCurve = .continuous
        cardBG.layer.cornerRadius = 15
        cardBG.layer.cornerCurve = .continuous
        bgPosterImage.layer.cornerRadius = 15
        bgPosterImage.layer.cornerCurve = .continuous
        visBlur.layer.cornerRadius = 15
        visBlur.clipsToBounds = true
        visBlur.layer.cornerCurve = .continuous
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
