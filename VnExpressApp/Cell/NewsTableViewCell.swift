//
//  NewsTableViewCell.swift
//  VnExpressApp
//
//  Created by Nam Pham on 08/12/2022.
// 

import Nuke
import UIKit

class NewsTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var Title: UILabel!
    @IBOutlet weak var Description: UILabel!
    @IBOutlet weak var Img: UIImageView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var item: News!{
        
        
        didSet{
            Title.numberOfLines = 1
            Title.lineBreakMode = .byTruncatingTail
            Title.adjustsFontSizeToFitWidth = false
            
            Title.text = item.title
            Description.text = item.descrip
            if item.urlImg.isEmpty{
                self.Img.image = UIImage(named: "test2")
            }else{
                downloadImage(from: URL(string: item.urlImg)! )
            }
            
//
          
           
//
            
        }
        
        
    }
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else {
                
                return
            }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            // always update the UI from the main thread
            DispatchQueue.main.async() { [weak self] in
                self?.Img.image = UIImage(data: data)
            }
        }
    }
    
}
