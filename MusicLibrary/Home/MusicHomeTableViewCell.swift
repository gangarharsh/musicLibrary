//
//  MusicHomeTableViewCell.swift
//  MusicLibrary
//
//  Created by Harsh Gangar on 01/07/20.
//

import UIKit

class MusicHomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var labeltrackName: UILabel!
    @IBOutlet weak var labelArtistName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.labelArtistName.textColor = .white
        self.labeltrackName.textColor = .white
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpCell(vmObj:MusicViewModel){
        labeltrackName.text = vmObj.trackName
        labelArtistName.text = vmObj.artistName
        imageView?.downloadImage(urlString: vmObj.image)
    }
}
