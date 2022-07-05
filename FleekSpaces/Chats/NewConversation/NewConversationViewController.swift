//
//  NewConversationViewController.swift
//  FleekSpaces
//
//  Created by Mayur P on 29/06/22.
//

import UIKit
import JGProgressHUD

class NewConversationViewController: UIViewController {

    public var completion: (([String: String]) -> (Void))?
    private let spinner = JGProgressHUD(style: .dark)
    private var users = [[String: String]]()
    private var results = [[String: String]]()
    private var hasFetched = false
    private let searchBar: UISearchBar = {
        
        let searchbar = UISearchBar()
        searchbar.placeholder = "Search for users"
        return searchbar
        
    }()
    
    private let tableView: UITableView = {
        
        let table = UITableView()
        table.isHidden = true
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
        
    }()
    
    private let noResultsLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "No Results"
        label.textAlignment = .center
        label.textColor = .systemTeal
        label.font = .systemFont(ofSize: 21, weight: .medium)
        return label
    }()
    
    override func viewDidLayoutSubviews() {
        tableView.frame = view.bounds
        noResultsLabel.frame = view.bounds
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(noResultsLabel)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.barStyle = .black
        tableView.backgroundColor = UIColor(named: "BGColor")
        searchBar.becomeFirstResponder()
        searchBar.delegate = self
        view.backgroundColor = UIColor(named: "BGColor")
        searchBar.tintColor = .white
       
        navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dismissSelf))
        navigationItem.rightBarButtonItem?.tintColor = .white
        
        // Do any additional setup after loading the view.
    }
    
    @objc private func dismissSelf() {
        
        dismiss(animated: true)
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


extension NewConversationViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let text = searchBar.text, !text.replacingOccurrences(of: " ", with: "").isEmpty else {
            
            return
        }
        
        searchBar.resignFirstResponder()
        
        results.removeAll()
        spinner.show(in: view)
        
        self.searchUsers(query: text)
    }
    
    
    func searchUsers(query: String) {
        //check if array has firebase results
        if hasFetched {
            filterUsers(with: query)
            
            //if it does: filters
        } else {
            
            
            //if not, fetch then filter
            
           
        }
        
        
        
       
        
    }
    
    
    
    func filterUsers(with term: String) {
        //update the UI
        guard hasFetched else {
            return
            
        }
        self.spinner.dismiss(animated: true)
        
        var results: [[String: String]] = self.users.filter({ guard let name = $0["name"]?.lowercased() else {
            return false
        }
            
            return name.hasPrefix(term.lowercased())
        })
        
    
        self.results = results
        
        updateUI()
    }
    
    func updateUI() {
        
        if results.isEmpty {
            self.noResultsLabel.isHidden = false
            self.tableView.isHidden = true
        } else {
            
            self.noResultsLabel.isHidden = true
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
    }
    
}

extension NewConversationViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = results[indexPath.row]["name"]
        cell.textLabel?.textColor = .white
        cell.backgroundColor = .black
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //TODO: - Start conversation here
        let targetUserData = results[indexPath.row]
        dismiss(animated: true, completion:  { [weak self] in
            self?.completion?(targetUserData)
        })
        
        
    }
}
