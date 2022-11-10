//
//  MediaViewCell.swift
//  CameraApp
//
//  Created by Kateryna Avramenko on 09.11.22.
//

import UIKit
import AVFoundation

class MediaViewCell: UITableViewCell {
    
    @IBOutlet weak var preview: UIImageView!
    var previewURL: URL!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(url: URL) {
        previewURL = url
        
        if url.pathExtension == "mov" {
            let image = thumbnailImageFor(fileUrl: url)
            preview.image = image
        } else {
            let data = try! Data(contentsOf: url)
            preview.image = UIImage(data: data)
        }
    
    }
    
    func thumbnailImageFor(fileUrl:URL) -> UIImage? {

        let video = AVURLAsset(url: fileUrl, options: [:])
        let assetImgGenerate = AVAssetImageGenerator(asset: video)
        assetImgGenerate.appliesPreferredTrackTransform = true

        let videoDuration: CMTime = video.duration

        let numerator = Int64(1)
        let denominator = videoDuration.timescale
        let time = CMTimeMake(value: numerator, timescale: denominator)

        do {
            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            let thumbnail = UIImage(cgImage: img)
            return thumbnail
        } catch {
            print(error)
            return nil
        }
    }

}
