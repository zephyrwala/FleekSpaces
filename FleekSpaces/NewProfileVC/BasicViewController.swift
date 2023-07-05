//
//  BasicViewController.swift
//  FleekSpaces
//
//  Created by Mayur P on 11/03/23.
//

import UIKit
import Parchment

//MARK: Icon struct remains the same
struct IconItem: PagingItem, Hashable {
    let icon: String
    let index: Int
    let image: UIImage?

    init(icon: String, index: Int) {
        self.icon = icon
        self.index = index
        image = UIImage(systemName: icon)
    }

    /// By default, isBefore is implemented when the PagingItem conforms
    /// to Comparable, but in this case we want a custom implementation
    /// where we also compare IconItem with PagingIndexItem. This
    /// ensures that we animate the page transition in the correct
    /// direction when selecting items.
    func isBefore(item: PagingItem) -> Bool {
        if let item = item as? PagingIndexItem {
            return index < item.index
        } else if let item = item as? Self {
            return index < item.index
        } else {
            return false
        }
    }
}


class BasicViewController: PagingViewController, PagingViewControllerDataSource, PagingViewControllerSizeDelegate {
    func pagingViewController(_: Parchment.PagingViewController, widthForPagingItem pagingItem: Parchment.PagingItem, isSelected: Bool) -> CGFloat {
        return 100
    }
    
    let pagingViewController = PagingViewController()
    fileprivate let icons = [
        "video.badge.checkmark",
        "hand.thumbsup",
        "shared.with.you",
        "person.fill.checkmark",
        "person.3.sequence"
       
    ]
    
  
//    private var movies = [
//
//        "   📺   ",
//        "   👍🏼   ",
//        "   👥  ",
//        "   🙇   ",
//        "   👥   "
//
//
//
//    ]
    
    
  

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

    override func viewDidLoad() {
        super.viewDidLoad()

      
       
       
      
        pagingViewController.register(IconPagingCell.self, for: IconItem.self)
        pagingViewController.menuItemSize = .fixed(width: 60, height: 60)
        pagingViewController.dataSource = self
        pagingViewController.select(pagingItem: IconItem(icon: icons[0], index: 0))

        pagingViewController.sizeDelegate = self
        menuItemSize = .fixed(width: 100, height: 50)
       
        
        pagingViewController.menuBackgroundColor = UIColor(named: "BGColor")!
        pagingViewController.indicatorColor = UIColor(named: "AAI")!
        pagingViewController.textColor = .darkGray
//        pagingViewController.selectedTextColor = UIColor(named: "AAI_Text")!
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
    
    
   
    

}
