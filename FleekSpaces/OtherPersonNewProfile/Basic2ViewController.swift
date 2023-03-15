//
//  Basic2ViewController.swift
//  FleekSpaces
//
//  Created by Mayur P on 15/03/23.
//

import UIKit
import Parchment

class Basic2ViewController: PagingViewController, PagingViewControllerDataSource, PagingViewControllerSizeDelegate {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
       
       
      
        pagingViewController.register(IconPagingCell.self, for: IconItem.self)
        pagingViewController.menuItemSize = .fixed(width: 60, height: 60)
        pagingViewController.dataSource = self
        pagingViewController.select(pagingItem: IconItem(icon: icons[0], index: 0))

        pagingViewController.sizeDelegate = self
        menuItemSize = .fixed(width: 100, height: 50)
       
        
        pagingViewController.menuBackgroundColor = UIColor(named: "BGColor")!
        pagingViewController.indicatorColor = .systemTeal
        pagingViewController.textColor = .darkGray
        pagingViewController.selectedTextColor = .systemCyan
        var uiedge = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        pagingViewController.select(index: 1)
//        pagingViewController.borderOptions = .visible(height: 3, zIndex: 0, insets: uiedge)
        pagingViewController.borderColor = .darkGray
          // Add the paging view controller as a child view controller
        // and contrain it to all edges.
        addChild(pagingViewController)
        view.addSubview(pagingViewController.view)
        view.constrainToEdges(pagingViewController.view)
        pagingViewController.didMove(toParent: self)
//        let viewControllers = [
//            ContentViewController(index: 0),
//            ContentViewController(index: 1),
//           LoadsViewController(),
//            vc
//
//        ]

//        let pagingViewController = PagingViewController(viewControllers: viewControllers)
//
//
//        // Make sure you add the PagingViewController as a child view
//        // controller and constrain it to the edges of the view.
//        addChild(pagingViewController)
//        view.addSubview(pagingViewController.view)
//        view.constrainToEdges(pagingViewController.view)
//        pagingViewController.didMove(toParent: self)
    }
    
    
    func pagingViewController(_: Parchment.PagingViewController, widthForPagingItem pagingItem: Parchment.PagingItem, isSelected: Bool) -> CGFloat {
        return 100
    }
    
    let pagingViewController = PagingViewController()
    fileprivate let icons = [
        "video.badge.checkmark",
        "hand.thumbsup",
        "person.line.dotted.person.fill",
        "person.fill.checkmark",
        "person.3.sequence"
       
    ]
    
  
    
    
    func numberOfViewControllers(in pagingViewController: Parchment.PagingViewController) -> Int {
        viewControllers.count
    }
    

    
    
    func pagingViewController(_: Parchment.PagingViewController, viewControllerAt index: Int) -> UIViewController {
       
      
        return viewControllers[index]
       
    }
    
    
    func pagingViewController(_: Parchment.PagingViewController, pagingItemAt index: Int) -> Parchment.PagingItem {
        return IconItem(icon: icons[index], index: index)
    }
    
    
    let viewControllers = [
        WatchViewController(),
        LikeListViewController(),
       RecommendListVC(),
        FollowingsViewController(),
        FollowersViewController()
//        SpacesTableViewController()
       
    ]
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
