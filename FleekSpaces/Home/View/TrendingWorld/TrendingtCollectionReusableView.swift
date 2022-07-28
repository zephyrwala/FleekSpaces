//
//  TrendingtCollectionReusableView.swift
//  FleekSpaces
//
//  Created by Mayur P on 09/06/22.
//
protocol TVshowTap {
    func tvShowSelected()
    func movieSelected()
}
import UIKit

class TrendingtCollectionReusableView: UICollectionReusableView {
    
    var movieDelegate : TVshowTap?
    @IBOutlet weak var myButton: UIButton!
    var menuItems: [UIAction] {
        return [
            UIAction(title: "Movies", image: UIImage(systemName: "film"), handler: { (_) in
              
                self.movieDelegate?.movieSelected()
                
            }),
            UIAction(title: "TV Show", image: UIImage(systemName: "tv"), handler: { (_) in
                
                self.movieDelegate?.tvShowSelected()
            })
        ]
    }

    var demoMenu: UIMenu {
        return UIMenu(title: "Choose", image: nil, identifier: nil, options: [], children: menuItems)
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureButtonMenu()
    }
    
    func configureButtonMenu() {
        myButton.menu = demoMenu
        myButton.showsMenuAsPrimaryAction = true
    }
    
}
