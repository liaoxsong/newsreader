


import UIKit

extension UIImage {
    
    //used in ArticlesViewController
    func fitImageToWidth(newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(newSize)
        self.drawInRect(CGRect(x: 0, y: 0, width: newSize.width, height: newSize.width))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
}

