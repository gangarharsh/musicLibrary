//
//  Player.swift
//  MusicLibrary
//
//  Created by Harsh Gangar on 02/07/20.
//

import Foundation
import UIKit
import AVFoundation

class VideoPlayerView: UIView {
    var player: AVPlayer? {
        get {
            return playerLayer.player
        }

        set {
            playerLayer.player = newValue
        }
    }

    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }

    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
}
