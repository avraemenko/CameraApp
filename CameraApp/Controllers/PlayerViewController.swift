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

final class PlayerViewController: UIViewController{
    
    var player: AVPlayer?
    var receivedUrl: URL!
    var allUrls: [URL] = []
    private var isPlaying = false
    private var volumeOn = false
    var index = 0
    
    //MARK: IBOUTLETS
    @IBOutlet private weak var playerContainer: UIView!
    @IBOutlet private weak var volumeButton: UIButton!
    @IBOutlet private weak var saveToGalleryButton: UIButton!
    @IBOutlet private weak var playStopButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure(url: receivedUrl)
    }
    
    func configure(url: URL){
        self.loadViewIfNeeded()
        receivedUrl = url
        if url.pathExtension == "mov" {
            player = .init(url: url)
            NotificationCenter.default.addObserver(self, selector: #selector(videoDidEnded), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
            let layer = AVPlayerLayer(player: player)
            layer.videoGravity = .resizeAspect
            layer.frame = playerContainer.bounds
            playerContainer.layer.addSublayer(layer)
            setUpVideoView()
        }
        else {
            let data = try! Data(contentsOf: url)
            let image = UIImage(data: data)
            let imageView = UIImageView(image: image!)
            imageView.frame = playerContainer.bounds
            imageView.contentMode = .scaleAspectFit
            playerContainer.addSubview(imageView)
            playStopButton.isHidden = true
            volumeButton.isHidden = true
            playStopButton.isUserInteractionEnabled = false
            volumeButton.isUserInteractionEnabled = false
        }
    }
    
    @objc private func videoDidEnded() {
        if index != allUrls.count - 1 {
            index = index + 1
            configure(url: allUrls[index])
            self.viewDidLoad()
        } else {
            displayAlert(message: "This is the last item in the gallery.")
        }
    }
    
    func setUpVideoView(){
        playStopButton.isHidden = false
        volumeButton.isHidden = false
        playStopButton.isUserInteractionEnabled = true
        volumeButton.isUserInteractionEnabled = true
        playStopButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        playStopButton.setTitle("play", for: .normal)
        volumeButton.setImage(UIImage(systemName: "volume.slash.fill"), for: .normal)
    }
    
    func displayAlert(message : String) {
        let alert = UIAlertController(title: "Message :)", message: message, preferredStyle: UIAlertController.Style.alert)
               alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
               self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func togglePlay() {
        isPlaying.toggle()
        isPlaying ? player?.play() : player?.pause()
        isPlaying ?
        playStopButton.setImage(UIImage(systemName: "pause.fill"), for: .normal) : playStopButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
        isPlaying ? playStopButton.setTitle("pause", for: .normal) :  playStopButton.setTitle("play", for: .normal)
    }
    
    @IBAction func playNext(_ sender: Any) {
        if index != allUrls.count - 1 {
            index = index + 1
            configure(url: allUrls[index])
            self.viewDidLoad()
        } else {
            displayAlert(message: "This is the last item in the gallery.")
        }
    }
    
    
    @IBAction func playPrevious(_ sender: Any) {
        if index != 0 {
            index = index - 1
            configure(url: allUrls[index])
        } else {
            displayAlert(message: "This is the first item in the gallery.")
        }
    }
    
    
    @IBAction func toggleVolume(_ sender: Any) {
        volumeOn.toggle()
        player?.isMuted = volumeOn
        volumeOn ?
        volumeButton.setImage(UIImage(systemName: "volume.3.fill"), for: .normal) : volumeButton.setImage(UIImage(systemName: "volume.slash.fill"), for: .normal)
        
    }
    
    @IBAction func saveToGallery(_ sender: Any) {
        let data =  NSData(contentsOf: self.allUrls[index])
        PHPhotoLibrary.shared().performChanges{
            PHAssetCreationRequest.forAsset().addResource(with: .photo, data: data! as Data, options: nil)
        }
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: self.allUrls[self.index])
                    }) { saved, error in
                        if saved {
                            DispatchQueue.main.async {
                                let alertController = UIAlertController(title: "Your video was successfully saved", message: nil, preferredStyle: .alert)
                                let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                                alertController.addAction(defaultAction)
                                self.present(alertController, animated: true, completion: nil)
                            }
                        }
                    }
        displayAlert(message: "The content was saved to the gallery.")
    }
    
    
}
    
