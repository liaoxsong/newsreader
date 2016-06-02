import UIKit

class ArticleViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var article: Article!
    
    @IBOutlet weak var articleTable: UITableView!
    
    //view constants
    let removeableTag = 122
    let categoryIconXOffset: CGFloat = -40
    let navigationAndStatusBarHeight: CGFloat = 64
    let sideMargin: CGFloat = 15
    let verticalMargin: CGFloat = 15
    let sectionLabelFontSize: CGFloat = 18
    
    var scrollview: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        
        return
        
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
        let favoriateIconDimension: CGFloat = 45, smallTextFontSize: CGFloat = 13
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
        
        let bannerText = UITextView(frame: CGRect(x: 0, y: CGRectGetMaxY(banner.frame), width: self.view.frame.width, height: 50))
        bannerText.backgroundColor = UIColor.navigationGreyColor()
        bannerText.text = Constants.BANNERTEXT
        bannerText.textColor = UIColor.lightGrayColor()
        bannerText.font = UIFont.italicSystemFontOfSize(smallTextFontSize)
        bannerText.editable = false
        bannerText.scrollEnabled = false
        bannerText.textContainerInset = UIEdgeInsets(top: 8, left: sideMargin, bottom: 8, right: sideMargin)
        scrollview.addSubview(bannerText)
     
        //add second paragraph below the banner
        let paragraphB = UITextView(frame: CGRect(x: sideMargin, y: CGRectGetMaxY(bannerText.frame) + verticalMargin, width: self.view.frame.width - 2 * sideMargin, height: 100))
        paragraphB.styleParagraphWithText(Constants.DUMMYTEXT)
        scrollview.addSubview(paragraphB)
        
        //====Section: similar articles
        let similarArticlesLabel = UILabel(frame: CGRect(x: sideMargin, y: CGRectGetMaxY(paragraphB.frame), width: self.view.frame.width - 2 * sideMargin, height: 30))
        similarArticlesLabel.textColor = UIColor.appBlueColor()
        similarArticlesLabel.font = UIFont.systemFontOfSize(sectionLabelFontSize)
        similarArticlesLabel.text = "Similar Articles"
        scrollview.addSubview(similarArticlesLabel)
        
        //create four image sections
        let gapBetweenArticles: CGFloat = sideMargin
        let imageDimension: CGFloat = (self.view.frame.width - 2 * sideMargin - gapBetweenArticles)/2
        
        //top left article
        let articleTopLeft = UIImageView(frame: CGRect(x: sideMargin, y: CGRectGetMaxY(similarArticlesLabel.frame) + verticalMargin/2, width: imageDimension, height: imageDimension))
        articleTopLeft.image = UIImage(named: "ic_arts")
        scrollview.addSubview(articleTopLeft)
        appendTextViewToArticle(imageFrame: articleTopLeft.frame, text: "More arts!")
        
        //top right article
        let articleTopRight = UIImageView(frame: CGRect(x: CGRectGetMaxX(articleTopLeft.frame) + gapBetweenArticles, y: articleTopLeft.frame.origin.y, width: imageDimension, height: imageDimension))
        articleTopRight.image = UIImage(named: "ic_business")
        scrollview.addSubview(articleTopRight)
        appendTextViewToArticle(imageFrame: articleTopRight.frame, text: "A nice business trip")
        
        //bottom left
        let articleBottomLeft = UIImageView(frame: CGRect(x: sideMargin, y: CGRectGetMaxY(articleTopLeft.frame) + verticalMargin * 3, width: imageDimension, height: imageDimension))
        articleBottomLeft.image = UIImage(named: "ic_science")
        scrollview.addSubview(articleBottomLeft)
        appendTextViewToArticle(imageFrame: articleBottomLeft.frame, text: "Science with a long name")

        //bottom right
        let articleBottomRight = UIImageView(frame: CGRect(x: articleTopRight.frame.origin.x, y: CGRectGetMaxY(articleTopLeft.frame) + verticalMargin * 3, width: imageDimension, height: imageDimension))
        articleBottomRight.image = UIImage(named: "ic_science")
        scrollview.addSubview(articleBottomRight)
        appendTextViewToArticle(imageFrame: articleBottomRight.frame, text: "Nope it wasn't alien")
        
        
        //add table view of comments
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
    
    //MARK: table view header, use the header to create everything except the view
    func getCategoryIconDimension() -> CGFloat {
        return self.view.frame.width/2
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCellWithIdentifier("HeaderCell") as! HeaderCell
        
        createViews(cell)
        
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let cell = tableView.dequeueReusableCellWithIdentifier("HeaderCell") as! HeaderCell
        for view in cell.subviews {
            print(CGRectGetMaxY(view.frame))
        }
        
        print("headerMaxY: \(headerMaxY)")
        return headerMaxY
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        tableView.tableFooterView?.hidden = true
        return 1.0
    }
    
    
    //MARK: tableview delegates
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return article.comments.count
    }
    
   
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CommentCell", forIndexPath: indexPath) as! CommentCell
        
        let comment = article.comments[indexPath.row]
        cell.commentDateTimeLabel.text = comment.dateTime
        cell.commentLabel.text = comment.text
        return cell
    }

    //allow dynamic height for each cell
    func configureTableView() {
        articleTable.rowHeight = UITableViewAutomaticDimension
        articleTable.estimatedRowHeight = 44.0
        
        articleTable.sectionHeaderHeight = UITableViewAutomaticDimension;
        articleTable.estimatedSectionHeaderHeight = 25;
    }
    
    var headerMaxY: CGFloat = 0
}


extension ArticleViewController {
    
    private func createViews(header: UIView) {
            
            //create views programatically to ensure sizes fit height
//        self.scrollview = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width
//                , height: self.view.frame.height))
//        scrollview.contentSize = CGSizeMake(0, self.view.frame.height * 2)
//        scrollview.bounces = false
//        self.view.addSubview(scrollview)
        
        //self.scrollView.frame =
        
        let blueOverlay = UIView(frame: CGRect(x: 0, y: -navigationAndStatusBarHeight, width: self.view.frame.width, height: getCategoryIconDimension()))
        blueOverlay.backgroundColor = UIColor.appBlueColor()
        header.addSubview(blueOverlay)
        
        //lower half of the catogory icon
        let lowerCategoryIcon = UIImageView(frame: CGRect(x: categoryIconXOffset, y: -navigationAndStatusBarHeight, width: getCategoryIconDimension(), height: getCategoryIconDimension()))
        lowerCategoryIcon.image = article.getCategoryImage()
        header.addSubview(lowerCategoryIcon)
        
        
        //add label for datetime and byline
        let favoriateIconDimension: CGFloat = 45, smallTextFontSize: CGFloat = 13
        let bylineText = UITextView(frame: CGRect(x: sideMargin, y: CGRectGetMaxY(blueOverlay.frame) + verticalMargin, width: self.view.frame.width - 3 * sideMargin - favoriateIconDimension, height: 30))
        bylineText.font = UIFont.systemFontOfSize(smallTextFontSize)
        bylineText.textColor = UIColor.lightGrayColor()
        bylineText.text = "\(article.publicationDate)\n\(article.author)"
        bylineText.sizeToFit()
        bylineText.editable = false
        header.addSubview(bylineText)
        
        let favoriteIcon = UIImageView(frame: CGRect(x: self.view.frame.width-sideMargin-favoriateIconDimension, y: 0, width: favoriateIconDimension, height: favoriateIconDimension))
        favoriteIcon.image = UIImage(named: "ic_like_full_large")
        favoriteIcon.contentMode = .ScaleAspectFit
        
        favoriteIcon.center.y = bylineText.center.y
        header.addSubview(favoriteIcon)
        
        let numberofFavoritesLabel = UILabel(frame: CGRect(origin: CGPointZero, size: favoriteIcon.frame.size))
        numberofFavoritesLabel.textColor = UIColor.whiteColor()
        numberofFavoritesLabel.font = UIFont.systemFontOfSize(smallTextFontSize)
        numberofFavoritesLabel.text = "\(article.numberOfLikes)"
        numberofFavoritesLabel.textAlignment = .Center
        numberofFavoritesLabel.center = favoriteIcon.center
        header.addSubview(numberofFavoritesLabel)
        
        
        headerMaxY = CGRectGetMaxY(numberofFavoritesLabel.frame)
       
        print("numberofFavoritesLabel \(CGRectGetMaxY(numberofFavoritesLabel.frame))")
        
        return
        
        //add first paragraph
        let paragraphA = UITextView(frame: CGRect(x: sideMargin, y: CGRectGetMaxY(bylineText.frame) + verticalMargin, width: self.view.frame.width - 2 * sideMargin, height: 100))
        paragraphA.styleParagraphWithText(article.paragraph.isEmpty ? Constants.DUMMYTEXT : article.paragraph)
        scrollview.addSubview(paragraphA)
        
        //add image banner
        let banner = UIImageView(frame: CGRect(x: 0, y: CGRectGetMaxY(paragraphA.frame) + verticalMargin, width: self.view.frame.width , height: 150))
        banner.image = UIImage(named: "article_image")
        banner.contentMode = UIViewContentMode.ScaleAspectFill
        scrollview.addSubview(banner)
        
        let bannerText = UITextView(frame: CGRect(x: 0, y: CGRectGetMaxY(banner.frame), width: self.view.frame.width, height: 50))
        bannerText.backgroundColor = UIColor.navigationGreyColor()
        bannerText.text = Constants.BANNERTEXT
        bannerText.textColor = UIColor.lightGrayColor()
        bannerText.font = UIFont.italicSystemFontOfSize(smallTextFontSize)
        bannerText.editable = false
        bannerText.scrollEnabled = false
        bannerText.textContainerInset = UIEdgeInsets(top: 8, left: sideMargin, bottom: 8, right: sideMargin)
        scrollview.addSubview(bannerText)
        
        //add second paragraph below the banner
        let paragraphB = UITextView(frame: CGRect(x: sideMargin, y: CGRectGetMaxY(bannerText.frame) + verticalMargin, width: self.view.frame.width - 2 * sideMargin, height: 100))
        paragraphB.styleParagraphWithText(Constants.DUMMYTEXT)
        scrollview.addSubview(paragraphB)
        
        //====Section: similar articles
        let similarArticlesLabel = UILabel(frame: CGRect(x: sideMargin, y: CGRectGetMaxY(paragraphB.frame), width: self.view.frame.width - 2 * sideMargin, height: 30))
        similarArticlesLabel.textColor = UIColor.appBlueColor()
        similarArticlesLabel.font = UIFont.systemFontOfSize(sectionLabelFontSize)
        similarArticlesLabel.text = "Similar Articles"
        scrollview.addSubview(similarArticlesLabel)
        
        //create four image sections
        let gapBetweenArticles: CGFloat = sideMargin
        let imageDimension: CGFloat = (self.view.frame.width - 2 * sideMargin - gapBetweenArticles)/2
        
        //top left article
        let articleTopLeft = UIImageView(frame: CGRect(x: sideMargin, y: CGRectGetMaxY(similarArticlesLabel.frame) + verticalMargin/2, width: imageDimension, height: imageDimension))
        articleTopLeft.image = UIImage(named: "ic_arts")
        scrollview.addSubview(articleTopLeft)
        appendTextViewToArticle(imageFrame: articleTopLeft.frame, text: "More arts!")
        
        //top right article
        let articleTopRight = UIImageView(frame: CGRect(x: CGRectGetMaxX(articleTopLeft.frame) + gapBetweenArticles, y: articleTopLeft.frame.origin.y, width: imageDimension, height: imageDimension))
        articleTopRight.image = UIImage(named: "ic_business")
        scrollview.addSubview(articleTopRight)
        appendTextViewToArticle(imageFrame: articleTopRight.frame, text: "A nice business trip")
        
        //bottom left
        let articleBottomLeft = UIImageView(frame: CGRect(x: sideMargin, y: CGRectGetMaxY(articleTopLeft.frame) + verticalMargin * 3, width: imageDimension, height: imageDimension))
        articleBottomLeft.image = UIImage(named: "ic_science")
        scrollview.addSubview(articleBottomLeft)
        appendTextViewToArticle(imageFrame: articleBottomLeft.frame, text: "Science with a long name")
        
        //bottom right
        let articleBottomRight = UIImageView(frame: CGRect(x: articleTopRight.frame.origin.x, y: CGRectGetMaxY(articleTopLeft.frame) + verticalMargin * 3, width: imageDimension, height: imageDimension))
        articleBottomRight.image = UIImage(named: "ic_science")
        scrollview.addSubview(articleBottomRight)
        appendTextViewToArticle(imageFrame: articleBottomRight.frame, text: "Nope it wasn't alien")
        
        
        //add table view of comments
    }
    
    private func appendTextViewToArticle(imageFrame imageFrame: CGRect, text: String) {
        let textVerticalMargin: CGFloat = 5, fontSize: CGFloat = 20
        let textUnderArticle = UILabel(frame: CGRect(x: imageFrame.origin.x, y: CGRectGetMaxY(imageFrame) + textVerticalMargin, width: imageFrame.size.width, height: 20))
        textUnderArticle.text = text
        textUnderArticle.textColor = UIColor.darkGrayColor()
        textUnderArticle.font = UIFont.systemFontOfSize(fontSize)
        scrollview.addSubview(textUnderArticle)
    }
    
}
