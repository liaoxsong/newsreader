

import Foundation
import Alamofire
import SwiftyJSON

class APIManager {

    static let BASE_URL = "https://api.nytimes.com/svc/"
    static let API_KEY_TOP_STORIES = "340fe1949bbc2b893c4a336bb072412a:18:74255139"
    static let API_KEY_ARTICLE_SEARCH = "a8457610b68381085a3fff38d6a36337:6:74255139"
    
    
    class func getTopStories(completion completion: ((articles: [Article]) -> Void)) {
     
        let parameters = ["api-key": API_KEY_TOP_STORIES]
        
        Alamofire.request(.GET, BASE_URL + "topstories/v2/home.json", parameters: parameters).responseJSON { response in
            switch response.result {
            case .Success:
                if let data = response.result.value {
                    let json = JSON(data)
                    //after completed, pass everything to the callback
                    //print(json)
                    
                    var articles = [Article]()
                    
                    guard let results = json["results"].array else {
                        print("no top stories")
                        return
                    }
                    for result in results {
                        let article = Article()
                        if let title = result["title"].string {
                            article.title = title
                        }
                        if let date = result["published_date"].string {
                            article.publicationDate = date
                        }
                        if let category = result["section"].string {
                            article.category = category
                        }
                        if let byline = result["byline"].string {
                            article.author = byline
                        }
                        if let abstract = result["abstract"].string {
                            article.paragraph = abstract
                        }
                        
                        //arbitrary
                        article.generateDemoData()
                    
                        articles.append(article)
                    }
                    completion(articles: articles)
                }
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    
    class func searchArticles(searchTerm: String, completion: ((articles: [Article]) -> Void)) {
        
        let parameters = ["api-key": API_KEY_ARTICLE_SEARCH, "q": searchTerm]
        
        Alamofire.request(.GET, BASE_URL + "search/v2/articlesearch.json", parameters: parameters).responseJSON { response in
            switch response.result {
            case .Success:
                if let data = response.result.value {
                    let json = JSON(data)
                    var articles = [Article]()
                    
                    
                    guard let results = json["response"]["docs"].array else {
                        print("no search results stories")
                        completion(articles: articles)
                        return
                    }
                    for result in results {
                        let article = Article()
                      
                        if let headline = result["headline"]["main"].string {
                            article.title = headline
                        }
                        
                        if let date = result["pub_date"].string {
                            article.publicationDate = date
                        }
                        if let category = result["section_name"].string {
                            article.category = category
                        }
                        if let byline = result["byline"]["original"].string {
                            article.author = byline
                        }
                        if let paragraph = result["lead_paragraph"].string {
                            article.paragraph = paragraph
                        }
                        article.generateDemoData()
                        
                      
                        articles.append(article)
                    }
                    completion(articles: articles)
                }
            case .Failure(let error):
                print(error)
            }
        }
        
    }
}