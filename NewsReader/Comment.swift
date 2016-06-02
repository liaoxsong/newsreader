
import Foundation

class Comment: NSObject {
    var avatarUrl = ""
    var dateTime = ""
    var text = ""
    
    init(url: String, date: String, text: String) {
        self.avatarUrl = url
        self.dateTime = date
        self.text = text
    }
}