//
//  DetailViewController.swift
//  VnExpressApp
//
//  Created by Nam Pham on 13/12/2022.
//

import UIKit

class DetailViewController: UIViewController {

    var linkRow: String!
    @IBOutlet weak var WebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(linkRow)
        
        let url = URL (string: linkRow)
                let requestObj = URLRequest(url: url!)
                WebView.loadRequest(requestObj)
        
    }
    

    

}
