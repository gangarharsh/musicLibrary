//
//  ImageView.swift
//  MusicLibrary
//
//  Created by Harsh Gangar on 29/06/20.
//

import Foundation
import UIKit

extension UIImageView{
    
    public func downloadImage(urlString: String) {
        if let url = URL(string: urlString){
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                DispatchQueue.main.async {
                    if let imageData = data{
                        self.image = UIImage(data: imageData)
                    }
                }
            }).resume()
        }else{
            print("invalid image URL \(urlString)")
        }
    }
    
}
