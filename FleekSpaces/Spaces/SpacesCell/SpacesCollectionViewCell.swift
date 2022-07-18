//
//  SpacesCollectionViewCell.swift
//  FleekSpaces
//
//  Created by Mayur P on 18/07/22.
//

import UIKit
import AVFoundation

struct VideoModel {
    
    let videoFileName: String
    let fileFormat: String
    
}

class SpacesCollectionViewCell: UICollectionViewCell {

    private var model: VideoModel?
    @IBOutlet weak var videosMainView: UIView!
    var player: AVPlayer?
    @IBOutlet weak var videoDescription: UILabel!
    @IBOutlet weak var videoTitle: UILabel!
    @IBOutlet weak var VideoView: UIView!
    @IBOutlet weak var moviePoster: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
        player = nil
        super.prepareForReuse()
        player?.pause()
    }
    
    func configure(with model: VideoModel){
        //configure
        self.model = model
     
        configureVideo()
    }
    
    private func configureVideo() {
            guard let model = model else {
                return
            }
            guard let path = Bundle.main.path(forResource: model.videoFileName,
                                              ofType: model.fileFormat) else {
                                                print("Failed to find video")
                                                return
            }
            player = AVPlayer(url: URL(fileURLWithPath: path))

            let playerView = AVPlayerLayer()
            playerView.player = player
            playerView.frame = contentView.bounds
            playerView.videoGravity = .resizeAspectFill
            videosMainView.layer.addSublayer(playerView)
            player?.volume = 3
            player?.play()
        }
}
