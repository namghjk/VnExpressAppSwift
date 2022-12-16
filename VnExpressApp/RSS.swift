//
//  RSS.swift
//  VnExpressApp
//
//  Created by Nam Pham on 09/12/2022.
//
import UIKit
import Foundation
import SwiftSoup


class FeedParser: NSObject,XMLParserDelegate{
    private var rssItems: [News]=[]
    private var currentElement = ""
    private var currentTitle:String = ""{
        didSet{
            currentTitle = currentTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentDesc:String = ""{
        didSet{
            currentDesc = currentDesc.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentLink:String = ""{
        didSet{
            currentLink = currentLink.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
     
    private var currentImg:String = ""{
        didSet{
            currentImg = currentImg.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
   
    
    private var parserCompletionHandler: (([News])->Void)?
    
    
    
    func parseFeed(url:String, comletionHandler:(([News])->Void)?){
        self.parserCompletionHandler  = comletionHandler
        
        let request = URLRequest(url: URL(string:url)!)
        let urlSession = URLSession.shared 
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            guard let data = data else{
                if let error = error {
                    print(error.localizedDescription)
                }
                return
            }
            //parse out xml data
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }
        
        task.resume()
        
    }
    
    //MARK: -XML Parser  Delegate
     
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        if(currentElement=="item"){
            currentTitle=""
            currentDesc=""
          
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "title": currentTitle += string
        case "description": currentDesc += string
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)  {
        
        if elementName == "item"{
            
            do {
                let html: String = currentDesc
                
                
                let doc: Document = try SwiftSoup.parse(html)
                
            
            
               
                if try !doc.select("img").isEmpty(){
                    let img: Element = try doc.select("img").first()!
                   
                    let linkImg: String = try img.attr("src")
                    currentImg = linkImg
                    
                } else {
                    let linkImg: String = ""
                    currentImg = linkImg
                }
                
                
            
         
                let text: String = try doc.body()!.text() // "An example link."
                currentDesc = text
               
               
                
                if try !doc.select("a").isEmpty(){
                    let text2: Element = try doc.select("a").first()!
                    
                    let link: String = try text2.attr("href")
                    
                   
                    currentLink = link
                  
                } else {
                    let text:String = "https://vnexpress.net"
                    currentLink = text
                }
             
                
                
 
                
            } catch Exception.Error(let type, let message) {
                print(message)
            } catch {
                print("error")
            }
       
            let rssItem = News(title: currentTitle, descrip: currentDesc,urlImg: currentImg,link: currentLink)
            self.rssItems.append(rssItem)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        parserCompletionHandler?(rssItems)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
    }
}
