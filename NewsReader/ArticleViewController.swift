import UIKit

class ArticleViewController: UIViewController {

    var article: Article!
    
    //constants
    let topIconTag = 122
    let categoryIconXOffset: CGFloat = -40
    let navigationAndStatusBarHeight: CGFloat = 64
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let blueOverlay = UIView(frame: CGRect(x: 0, y: -navigationAndStatusBarHeight, width: self.view.frame.width, height: getCategoryIconDimension()))
        blueOverlay.backgroundColor = UIColor.appBlueColor()
        self.view.addSubview(blueOverlay)
        
        let lowerCategoryIcon = UIImageView(frame: CGRect(x: categoryIconXOffset, y: -navigationAndStatusBarHeight, width: getCategoryIconDimension(), height: getCategoryIconDimension()))
        lowerCategoryIcon.image = article.getCategoryImage()
       

        self.view.addSubview(lowerCategoryIcon)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        //make navigation bar's border transparent
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
      
        //add category icon in top-left area of navigation bar, scale the image, and only show the height covered by the navigation bar
        let icon = UIImageView(frame: CGRect(x: categoryIconXOffset, y: -20/*status bar height*/, width: getCategoryIconDimension(), height: navigationAndStatusBarHeight))
        icon.tag = topIconTag
        icon.image = scaleImage(article.getCategoryImage()!, newSize: icon.frame.size)
        self.navigationController?.navigationBar.addSubview(icon)
        
        self.navigationController?.navigationBar.barTintColor = UIColor.appBlueColor()
        self.navigationController?.navigationBar.topItem?.title = "" //hide back button text
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor() //change back button color
    }

    func scaleImage(image: UIImage, newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(newSize)
        image.drawInRect(CGRect(x: 0, y: 0, width: newSize.width, height: newSize.width))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.barTintColor = UIColor.navigationGreyColor()
        self.navigationController?.navigationBar.tintColor = UIColor.appBlueColor()
        for view in (self.navigationController?.navigationBar.subviews)! {
            if view.tag == topIconTag {
                view.removeFromSuperview()
            }
        }
    }
    
   
    func getCategoryIconDimension() -> CGFloat {
        return self.view.frame.width/2
    }
}
