
import Foundation
import UIKit

enum Category : String {
    case Arts = "Arts",
    Business = "Business",
    Politics = "Politics",
    Science = "Science",
    Sports = "Sports"
    
    static let all = [Arts, Business, Politics, Science, Sports]
}

class Article: NSObject {

    var title = ""
    var publicationDate = ""
    var category = ""
    var paragraph = ""
    var author = ""
    var numberOfLikes = 0
    var numberOfComments = 0
    var liked = false
    
    func getCategoryImage() -> UIImage? {
        if category.isEmpty {
            return UIImage(named: "ic_politics") //default
        }
        
        if category == Category.Arts.rawValue {
            return UIImage(named: "ic_arts")
        } else if category == Category.Business.rawValue {
             return UIImage(named: "ic_business")
        } else if category == Category.Sports.rawValue {
            return UIImage(named: "ic_sports")
        } else if category == Category.Science.rawValue {
          return UIImage(named: "ic_science")
        }
        return UIImage(named: "ic_politics")
    }
    
    //for demo purpose
    func generateDemoData () {
        numberOfComments = Int(arc4random_uniform(20))
        numberOfLikes = Int(arc4random_uniform(50))
        liked = Int(arc4random_uniform(3)) == 0 ? true : false
    }
    
}