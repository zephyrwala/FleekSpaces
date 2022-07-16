//
//  BookSectionCollectionViewCell.swift
//  FleekSpaces
//
//  Created by Mayur P on 16/07/22.
//

import UIKit

protocol previewBtn {
    func didTapPreviewBtn(sender: UIButton)
}

class BookSectionCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var bookAuthor: UILabel!
    var previewDelegate: previewBtn?
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var previewBtn: UIButton!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var posterImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func previewBtnTap(_ sender: UIButton) {
        previewDelegate?.didTapPreviewBtn(sender: sender)
    }
    
    func setupCell(fromData: Logos){
        self.posterImage.image = fromData.posterImage
        self.backgroundImage.image = fromData.posterImage
        self.previewBtn.layer.cornerRadius = 6
        self.bookTitle.text = fromData.bookName
        self.bookAuthor.text = fromData.author
        self.posterImage.layer.cornerRadius = 4
        
    }

}
