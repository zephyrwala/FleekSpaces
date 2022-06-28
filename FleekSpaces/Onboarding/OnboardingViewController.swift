//
//  OnboardingViewController.swift
//  FleekSpaces
//
//  Created by Mayur P on 16/06/22.
//

import UIKit

class OnboardingViewController: UIViewController {

    @IBOutlet weak var myPageControl: UIPageControl!
    @IBOutlet weak var NextBtn: UIButton!
    @IBOutlet weak var onboardingCollectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
   
    @IBOutlet weak var titleDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupNextBtn()
//        NextBtn.tintColor = .darkGray
        myPageControl.tintColor = .green
        // Do any additional setup after loading the view.
    }
    
    func setupNextBtn() {
        self.NextBtn.layer.cornerRadius = 16
    }
    
    private func setupViews() {
        self.titleLabel.text = Slide.slideCollection[0].title
        Slide.slideCollection[0].description
    }
    
    func showCaption(atIndex index: Int) {
        
        let slide = Slide.slideCollection[index]
        titleLabel.text = slide.title
        titleDescription.text = slide.description
        
    }
    
    private func setupCollectionView() {
       
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
//        layout.sectionInset.left = -10
        onboardingCollectionView.delegate = self
        onboardingCollectionView.dataSource = self
        onboardingCollectionView.collectionViewLayout = layout
        onboardingCollectionView.isPagingEnabled = true
        onboardingCollectionView.showsHorizontalScrollIndicator = false
        
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

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Slide.slideCollection.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let thisWidth  = view.bounds.width
        return CGSize(width: thisWidth, height: 400)
        }
  
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath) as! OnboardingCVC
        
        let imageName = Slide.slideCollection[indexPath.item].imageName
        let imageN = UIImage(named: imageName) ?? UIImage()
        cell.imagename.image = imageN
        
        return cell
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        showCaption(atIndex: index)
        print("index is \(index)")
        
        self.myPageControl.currentPage = index
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    
}
