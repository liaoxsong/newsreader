import UIKit

class ArticleViewController: UIViewController {

    var article: Article!
    
    let topIconTag = 122
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.barTintColor = UIColor.appBlueColor()
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.topItem?.title = "" //hide back button text
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor() //change back button color
        
        let icon = UIImageView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
        icon.tag = topIconTag
        icon.image = article.getCategoryImage()
        self.navigationController?.view.addSubview(icon)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.tintColor = UIColor.appBlueColor()
        for view in (self.navigationController?.view.subviews)! {
            if view.tag == topIconTag {
                view.removeFromSuperview()
            }
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
}
