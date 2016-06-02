
import Foundation
import UIKit

extension UITextView {
    
    func fitToHeight() {
        self.sizeToFit()
        self.layoutIfNeeded()
        let height = self.sizeThatFits(CGSizeMake(self.frame.size.width, CGFloat.max)).height
        self.contentSize.height = height
    }
    
    func styleParagraphWithText(text: String) {
        self.textColor = UIColor.darkGrayColor()
        self.editable = false
        self.scrollEnabled = false
        self.font = UIFont.systemFontOfSize(15)
        self.text = text
        self.fitToHeight()
        
    }
}