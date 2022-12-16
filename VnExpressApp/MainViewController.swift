//
//  MainViewController.swift
//  VnExpressApp
//
//  Created by Nam Pham on 08/12/2022.
//

import UIKit

class MainViewController: UIViewController,XMLParserDelegate {
    
    private   var news: [News]?

    @IBOutlet weak var MainTableView: UITableView!
    
    //data
    let data = ["Name","Two","threee" ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.MainTableView.register(UINib(nibName: "NewsTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        
        //set up Table VIew
        setUpTableView()
        
        //fetch Data
        fetchData()
    }
    
    private func setUpTableView(){
        MainTableView.dataSource = self
        MainTableView.delegate = self
    }
    
    private func fetchData(){
        let feedParser = FeedParser()
        feedParser.parseFeed(url: "https://vnexpress.net/rss/tin-moi-nhat.rss") { news in
            self.news = news
            
            OperationQueue.main.addOperation{
                self.MainTableView.reloadSections(IndexSet(integer: 0), with: .left)
            }
            
        }
    }

}


// MARK: - TbaleViewDelegate,DataSource

extension MainViewController:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let news = news else{
            return 0
        }
        
        return news.count
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        nextViewController.linkRow = news?[indexPath.item].link
        self.navigationController?.pushViewController(nextViewController, animated: true)
        
    }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NewsTableViewCell
        
        
        if let item = news?[indexPath.item]{
            cell.item = item
        }
//
        return cell
        
        }
        
       
    }
    
    
    
   
    
    

