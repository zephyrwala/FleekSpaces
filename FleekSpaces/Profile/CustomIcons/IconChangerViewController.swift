//
//  IconChangerViewController.swift
//  FleekSpaces
//
//  Created by Mayur P on 20/10/22.
//

import UIKit

class IconChangerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {


    @IBOutlet weak var mainIconImage: UIImageView!
    
    @IBOutlet weak var iconTableView: UITableView!
    
    var iconSet = [AltIcons(iconImage: "Diwali", iconName: "Diwali Diya"),
                   AltIcons(iconImage: "Diwali2", iconName: "Diwali Lantern"),
                   AltIcons(iconImage: "Halloween", iconName: "Haloween")
    
    
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        // Do any additional setup after loading the view.
    }


    func setupTableView() {
        
//        iconTableView.allowsMultipleSelection = true
        iconTableView.delegate = self
        iconTableView.dataSource = self
        iconTableView.register(UINib(nibName: "iconTableViewCell", bundle: nil), forCellReuseIdentifier: "icono")
        mainIconImage.layer.cornerRadius = 20
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        iconSet.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        
        print("\(iconSet[indexPath.row].iconImage)")
        UIApplication.shared.setAlternateIconName("Diwali") { error in
            
            guard error == nil else {
                return
            }
            
            print("Icon Updated")
            
        }
        
        
        
       
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "icono", for: indexPath) as! iconTableViewCell
        if let safeImagePath = iconSet[indexPath.row].iconImage {
            
            cell.iconImage.image = UIImage(named: "\(safeImagePath)")
        }
       
        if let safeIconName = iconSet[indexPath.row].iconName {
            
            cell.iconName.text = "\(safeIconName)"
        }
       
        
        cell.iconImage.layer.cornerRadius = 10
    
    
        
        
        return cell
    }
    
    

}



struct AltIcons {
    
    let iconImage: String?
    let iconName: String?
    
    
}

