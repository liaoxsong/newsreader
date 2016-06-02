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
        
        //create views programatically to ensure sizes fit height
        self.scrollview = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width
            , height: self.view.frame.height))
        scrollview.contentSize = CGSizeMake(0, self.view.frame.height * 2)
        scrollview.bounces = false
        self.view.addSubview(scrollview)
        
        let blueOverlay = UIView(frame: CGRect(x: 0, y: -navigationAndStatusBarHeight, width: self.view.frame.width, height: getCategoryIconDimension()))
        blueOverlay.backgroundColor = UIColor.appBlueColor()
        scrollview.addSubview(blueOverlay)
        
        //lower half of the catogory icon
        let lowerCategoryIcon = UIImageView(frame: CGRect(x: categoryIconXOffset, y: -navigationAndStatusBarHeight, width: getCategoryIconDimension(), height: getCategoryIconDimension()))
        lowerCategoryIcon.image = article.getCategoryImage()
        scrollview.addSubview(lowerCategoryIcon)
        
        //add label for datetime and byline
        let sideMargin: CGFloat = 15, verticalMargin: CGFloat = 15, favoriateIconDimension: CGFloat = 45, paragraphTextViewFontSize: CGFloat = 15, smallTextFontSize: CGFloat = 13
        let bylineText = UITextView(frame: CGRect(x: sideMargin, y: CGRectGetMaxY(blueOverlay.frame) + verticalMargin, width: self.view.frame.width - 3 * sideMargin - favoriateIconDimension, height: 30))
        bylineText.font = UIFont.systemFontOfSize(smallTextFontSize)
        bylineText.textColor = UIColor.lightGrayColor()
        bylineText.text = "\(article.publicationDate)\n\(article.author)"
        bylineText.sizeToFit()
        bylineText.editable = false
        scrollview.addSubview(bylineText)
        
        let favoriteIcon = UIImageView(frame: CGRect(x: self.view.frame.width-sideMargin-favoriateIconDimension, y: 0, width: favoriateIconDimension, height: favoriateIconDimension))
        favoriteIcon.image = UIImage(named: "ic_like_full_large")
        favoriteIcon.contentMode = .ScaleAspectFit
       
        favoriteIcon.center.y = bylineText.center.y
        scrollview.addSubview(favoriteIcon)
        
        let numberofFavoritesLabel = UILabel(frame: CGRect(origin: CGPointZero, size: favoriteIcon.frame.size))
        numberofFavoritesLabel.textColor = UIColor.whiteColor()
        numberofFavoritesLabel.font = UIFont.systemFontOfSize(smallTextFontSize)
        numberofFavoritesLabel.text = "\(article.numberOfLikes)"
        numberofFavoritesLabel.textAlignment = .Center
        numberofFavoritesLabel.center = favoriteIcon.center
        scrollview.addSubview(numberofFavoritesLabel)
     
        //add first paragraph
        let paragraphA = UITextView(frame: CGRect(x: sideMargin, y: CGRectGetMaxY(bylineText.frame) + verticalMargin, width: self.view.frame.width - 2 * sideMargin, height: 100))
        paragraphA.styleParagraphWithText(article.paragraph.isEmpty ? Constants.DUMMYTEXT : article.paragraph)
        scrollview.addSubview(paragraphA)
        
        //add image banner
        let banner = UIImageView(frame: CGRect(x: 0, y: CGRectGetMaxY(paragraphA.frame) + verticalMargin, width: self.view.frame.width , height: 150))
        banner.image = UIImage(named: "article_image")
        banner.contentMode = UIViewContentMode.ScaleAspectFill
        scrollview.addSubview(banner)
        
        let bannerText = UITextView(frame: CGRect(x: 0, y: CGRectGetMaxY(banner.frame), width: self.view.frame.width, height: 45))
        bannerText.backgroundColor = UIColor.navigationGreyColor()
        bannerText.text = Constants.BANNERTEXT
        bannerText.textColor = UIColor.lightGrayColor()
        bannerText.font = UIFont.italicSystemFontOfSize(smallTextFontSize)
        bannerText.editable = false
        bannerText.scrollEnabled = false
        bannerText.textContainerInset = UIEdgeInsets(top: 0, left: sideMargin, bottom: 0, right: sideMargin)
        scrollview.addSubview(bannerText)
     
        //add second paragraph below the banner
        let paragraphB = UITextView(frame: CGRect(x: sideMargin, y: CGRectGetMaxY(bannerText.frame) + verticalMargin, width: self.view.frame.width - 2 * sideMargin, height: 100))
        paragraphB.styleParagraphWithText(Constants.DUMMYTEXT)
        scrollview.addSubview(paragraphB)
        
     
        
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
