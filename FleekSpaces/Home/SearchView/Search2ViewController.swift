//
//  Search2ViewController.swift
//  FleekSpaces
//
//  Created by Mayur P on 17/03/23.
//

import UIKit

class Search2ViewController: UIViewController {

    @IBOutlet weak var searchTableView: UITableView!
   
    let searchController = UISearchController(searchResultsController: nil)
    override func viewDidLoad() {
        super.viewDidLoad()

        searchTableView.tableHeaderView = searchController.searchBar
        
      
      
        // Do any additional setup after loading the view.
    }

   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
