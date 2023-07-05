//
//  Section1CollectionViewCell.swift
//  FleekSpaces
//
//  Created by Mayur P on 01/06/22.
//

import UIKit
import SDWebImage

class GradientBorderView: UIView {
    var gradientColors: [UIColor] = [.systemGreen, .systemMint] {
        didSet {
            setNeedsLayout()
        }
    }
}

class Section1CollectionViewCell: UICollectionViewCell {
    
   
    @IBOutlet weak var selectedSub: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        setNeedsLayout()
        if UIDevice.current.userInterfaceIdiom == .pad {
           
          
//            if self.isSelected == true {
//                self.selectedSub.alpha = 0.9
//            }else {
//                self.selectedSub.alpha = 0.1
//            }
//
//        } else {
            
        }
        // Initialization code
       
    }

    override var isSelected: Bool {
        
          willSet {
              if newValue {
                  
//                  guard let mainCOlor = UIColor(named: "Fleek_400") else {
//                      return
//                  }
                  self.layer.cornerRadius = selectedSub.frame.size.width / 2
                  let generator = UIImpactFeedbackGenerator(style: .light)
                             generator.impactOccurred()
                  self.layer.borderWidth = 4
                  UIView.animate(withDuration: 1) {
                      self.selectedSub.alpha = 1
                      self.transform = CGAffineTransform(scaleX: 1, y: 1)
                  }
                  var gradientColors: [UIColor] = [UIColor(named: "AAI")!, .red] {
                         didSet {
                             setNeedsLayout()
                         }
                     }
                  

                  let gradient = UIImage.gradientImage(bounds: bounds, colors: gradientColors)
                  self.layer.borderColor = UIColor(patternImage: gradient).cgColor
              } else {
                   self.layer.borderWidth = 0
                  self.layer.borderColor = UIColor(.gray).cgColor
                 
                  UIView.animate(withDuration: 1) {
                      self.selectedSub.alpha = 0.4
                      
                  }
                 
                
              }
          }
      }
      
   
    //MARK: - Setup cell with new api data
    func setupStreamCells(fromData: StreamingElement) {
       
        if let imageURL = fromData.iconURL {
            
//            self.selectedSub.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/original\(imageURL)"))
            
            self.selectedSub.sd_setImage(with: URL(string: "\(imageURL)"))
            
        }
       
//        selectedSub.makeItGolGol()
     
        selectedSub.layer.cornerRadius = selectedSub.frame.size.width / 2
        selectedSub.clipsToBounds = true

        selectedSub.layer.borderWidth = 1
        selectedSub.layer.borderColor = UIColor(named: "BtnGreenColor")?.cgColor
        
        
    }
  
    
    func setupCell(fromData: Results){
        
        //https://image.tmdb.org/t/p/original/
        let newURL = URL(string: "https://image.tmdb.org/t/p/original/\(fromData.posterPath!)")
        self.selectedSub.sd_setImage(with: newURL)
        

        selectedSub.makeItGolGol()
        
    }
    
    func setupLogos(fromData: Logos) {
        
        self.selectedSub.image = fromData.posterImage
//        selectedSub.layer.cornerRadius = 10
//        selectedSub.makeItGolGol()
        selectedSub.makeItGolGol()
        
    }
    
    func makeRounded() {

        selectedSub.layer.borderWidth = 1
        selectedSub.layer.masksToBounds = false
        selectedSub.layer.borderColor = UIColor.systemGray.cgColor
        selectedSub.layer.cornerRadius = selectedSub.frame.height/2 //This will change with corners of image and height/2 will make this circle shape
        selectedSub.clipsToBounds = true
  }
    
}




extension UIImage {
    static func gradientImage(bounds: CGRect, colors: [UIColor]) -> UIImage {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map(\.cgColor)

        // This makes it left to right, default is top to bottom
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)

        let renderer = UIGraphicsImageRenderer(bounds: bounds)

        return renderer.image { ctx in
            gradientLayer.render(in: ctx.cgContext)
        }
    }
}
