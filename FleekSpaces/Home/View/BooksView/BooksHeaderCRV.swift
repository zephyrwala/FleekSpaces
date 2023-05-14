//
//  BooksHeaderCRV.swift
//  FleekSpaces
//
//  Created by Mayur P on 15/07/22.
//

import UIKit

protocol CountrySelection {
    func indiaSelected()
    func usaSelected()
}

class BooksHeaderCRV: UICollectionReusableView {
    @IBOutlet weak var countrySelect: UIButton!
    
    var conutryDelegate: CountrySelection?
    var menuItems: [UIAction] {
        return [
            UIAction(title: "USA", image: UIImage(named: "usa"), handler: { (_) in
              
                self.conutryDelegate?.usaSelected()
                
            }),
            UIAction(title: "IND", image: UIImage(named: "inr"), handler: { (_) in
                
               
                self.conutryDelegate?.indiaSelected()
            })
        ]
    }
    
    var demoMenu: UIMenu {
        return UIMenu(title: "Choose Region", image: nil, identifier: nil, options: [], children: menuItems)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureButtonMenu()
    }
    
    
    func configureButtonMenu() {
        countrySelect.menu = demoMenu
        countrySelect.showsMenuAsPrimaryAction = true
    }
    
    
}
