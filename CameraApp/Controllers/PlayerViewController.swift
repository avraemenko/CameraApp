//
//  PlayerViewController.swift
//  CameraApp
//
//  Created by Kateryna Avramenko on 08.11.2022.
//

import Foundation
import AVFoundation
import UIKit
import Photos

final class PlayerViewController: UIViewController, ObservableObject{
    
    @Published var player: AVPlayer?
    @Published var receivedUrl: URL!
    private var isPlaying = false
    private var volumeOn = true
    @Published var playNext = false
    
    @IBOutlet weak var playerContainer: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure(url: receivedUrl)
    }
    
    func configure(url: URL){
       
        self.loadViewIfNeeded()
        receivedUrl = url
        if url.pathExtension == "mov" {
        player = .init(url: url)
        
        let layer = AVPlayerLayer(player: player)
        layer.videoGravity = .resizeAspect
        layer.frame = playerContainer.bounds
        
        playerContainer.layer.addSublayer(layer)
        
    }
    else {
        let data = try! Data(contentsOf: url)
        let image = UIImage(data: data)
        let imageView = UIImageView(image: image!)

        imageView.frame = playerContainer.bounds
        imageView.contentMode = .scaleAspectFit
        playerContainer.addSubview(imageView)
     
       
    }
    }
   

    @IBAction func togglePlay() {
        isPlaying.toggle()
        isPlaying ? player?.play() : player?.pause()
    }
    
    @IBAction func playNext(_ sender: Any) {
        self.playNext = true
        configure(url: receivedUrl)
    }
    
    
    @IBAction func playPrevious(_ sender: Any) {
    }
    
    
    @IBAction func toggleVolume(_ sender: Any) {
        volumeOn.toggle()
        volumeOn ? (player?.isMuted = true) : (player?.isMuted = false)
    }
    
    @IBAction func saveToGallery(_ sender: Any) {
//        PHPhotoLibrary.shared().performChanges{
//            PHAssetCreationRequest.forAsset().addResource(with: .photo, data: imageData, options: nil)
//        }
    }
    
}
