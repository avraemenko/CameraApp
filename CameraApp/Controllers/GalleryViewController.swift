//
//  GalleryViewController.swift
//  CameraApp
//
//  Created by Kateryna Avramenko on 09.11.22.
//

import Foundation
import UIKit

class GalleryViewController : UIViewController {
    
    @IBOutlet weak var tableView : UITableView!
    var urls: [URL]!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
}

extension GalleryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return urls.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MediaViewCell
        cell.configure(url: urls[indexPath.row])
        
        return cell
    }
    
    
}
