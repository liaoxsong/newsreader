import UIKit

class ArticleViewController: UIViewController {

    var article: Article!
    
    //constants
    let removeableTag = 122
    let categoryIconXOffset: CGFloat = -40
    let navigationAndStatusBarHeight: CGFloat = 64
    
    var scrollview: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollview = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width
            , height: self.view.frame.height))
        scrollview.contentSize = CGSizeMake(0, self.view.frame.height * 2)
        scrollview.bounces = false
        self.view.addSubview(scrollview)
        
        let blueOverlay = UIView(frame: CGRect(x: 0, y: -navigationAndStatusBarHeight, width: self.view.frame.width, height: getCategoryIconDimension()))
        blueOverlay.backgroundColor = UIColor.appBlueColor()
        scrollview.addSubview(blueOverlay)
        
        let lowerCategoryIcon = UIImageView(frame: CGRect(x: categoryIconXOffset, y: -navigationAndStatusBarHeight, width: getCategoryIconDimension(), height: getCategoryIconDimension()))
        lowerCategoryIcon.image = article.getCategoryImage()
       
        scrollview.addSubview(lowerCategoryIcon)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        //make navigation bar's border transparent
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
      
        //add category icon in top-left area of navigation bar, scale the image, and only show the height covered by the navigation bar
        let icon = UIImageView(frame: CGRect(x: categoryIconXOffset, y: -20/*status bar height*/, width: getCategoryIconDimension(), height: navigationAndStatusBarHeight))
        icon.tag = removeableTag
        icon.image = article.getCategoryImage()?.fitImageToWidth(icon.frame.size)
        self.navigationController?.navigationBar.addSubview(icon)
        
        //add title
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width * 0.7, height: 44))
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.text = article.title
        titleLabel.center.x = self.view.center.x
        titleLabel.tag = removeableTag
        self.navigationController?.navigationBar.addSubview(titleLabel)
        
        self.navigationController?.navigationBar.barTintColor = UIColor.appBlueColor()//change background color of navigation bar
        self.navigationController?.navigationBar.topItem?.title = "" //hide back button text
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor() //change back button color
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.barTintColor = UIColor.navigationGreyColor()
        self.navigationController?.navigationBar.tintColor = UIColor.appBlueColor()
        for view in (self.navigationController?.navigationBar.subviews)! {
            if view.tag == removeableTag {
                view.removeFromSuperview()
            }
        }
    }
    
   
    func getCategoryIconDimension() -> CGFloat {
        return self.view.frame.width/2
    }
}
