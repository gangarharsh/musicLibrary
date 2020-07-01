//
//  DetialsViewController.swift
//  MusicLibrary
//
//  Created by Harsh Gangar on 01/07/20.
//

import UIKit
import AVKit

class DetialsViewController: UIViewController {
    @IBOutlet weak var imageViewBand: UIImageView!
    @IBOutlet weak var labelAlbumName: UILabel!
    
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelSingerName: UILabel!
    
    @IBOutlet weak var viewPlayerBg: UIView!
    @IBOutlet weak var viewBg: UIView!
    var viewModel : MusicViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.preferredContentSize = CGSize(width: 100, height: 100)
        setUpdata()
        setupUI()

    }
    
    func setUpdata(){
        labelAlbumName.text = viewModel.trackName
        labelSingerName.text = viewModel.artistName
        labelPrice.text = viewModel.price
        imageViewBand.downloadImage(urlString: viewModel.image)
        if viewModel.isSteamable{
            viewPlayerBg.isHidden = false
            playVideo()
        }

    }
    
    func setupUI(){
        let gradient = CAGradientLayer()

        gradient.frame = viewBg.bounds
        gradient.colors = [UIColor.white.cgColor, UIColor.black.cgColor]
        viewBg.layer.insertSublayer(gradient, at: 0)
        self.imageViewBand.layer.zPosition = 1

    }
    
    func playVideo(){
        if let urlObj = URL(string: viewModel.streamURL){
            
            let player = AVPlayer(url: urlObj)
            let avPlayerController = AVPlayerViewController()
            
            avPlayerController.player = player;
            avPlayerController.view.frame = self.viewPlayerBg.bounds
            avPlayerController.showsPlaybackControls = true
            self.addChild(avPlayerController)
            self.viewPlayerBg.addSubview(avPlayerController.view);
        }
    }
}
