
import UIKit

class NewsListController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITabBarDelegate {
    
    @IBOutlet weak var searchButton: UIBarButtonItem!
    
    @IBOutlet weak var newsTableTopSpacing: NSLayoutConstraint!
    
    @IBOutlet weak var searchBar: SearchBar!
    
    let tableViewCellHeight: CGFloat = 85
    
    @IBOutlet weak var newsTable: UITableView!
    var articles = [Article]()
    var cachedStories = [Article]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        styleTableView()
        setUpSearchBar()
        
        APIManager.getTopStories(completion: {
            articles in
            self.cachedStories = articles
            self.articles = articles
            self.newsTable.reloadData()
        })
    }
    
    //change back title when transition from article to list
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.title = "Today's Headlines"
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor.navigationGreyColor()
    }
    
    private func styleTableView() {
        newsTable.separatorInset = UIEdgeInsets(top: 0, left: tableViewCellHeight-1, bottom: 0, right: 0)
        newsTable.tableFooterView = UIView(frame: CGRectZero)//no separator for empty cells
    }
    
    private func setUpSearchBar() {
        searchBar.searchTextField.borderStyle = .RoundedRect
        searchBar.searchTextField.addTarget(self, action: #selector(NewsListController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        searchBar.clearSearchButton.addTarget(self, action: #selector(NewsListController.clearSearch), forControlEvents: .TouchUpInside)
        
    }
    
    //MARK: tableview delegates
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.articles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NewsCell", forIndexPath: indexPath) as! NewsCell
        
        let article = articles[indexPath.row]
        
        cell.titleLabel.text = article.title
        cell.dateTimeLabel.text = article.publicationDate
        cell.likesLabel.text = String(article.numberOfLikes)
        cell.commentsLabel.text = String(article.numberOfComments)
        
        cell.likesIcon.image = article.liked ? UIImage(named: "ic_like_full_small") : UIImage(named: "ic_like_small")
        cell.categoryIcon.image = article.getCategoryImage()
        return cell
    }
    
    @IBOutlet weak var categoryIconDimension: NSLayoutConstraint!
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        view.endEditing(true)//hide keyboard
        
        let articleVC =   self.storyboard?.instantiateViewControllerWithIdentifier("ArticleViewController") as! ArticleViewController
        
        articleVC.article = articles[indexPath.row]
        self.showViewController(articleVC, sender: nil)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableViewCellHeight
    }
    
    //search bar related
    @IBAction func searchButtonClicked(sender: UIBarButtonItem) {
        
        if searchBar.hidden { //if hidden show search bar
            searchBar.hidden = false
            searchButton.image = UIImage(named : "ic_close")
            newsTableTopSpacing.constant = searchBar.frame.height
        } else { //hide search bar
            searchBar.hidden = true
            searchButton.image = UIImage(named : "ic_search")
            newsTableTopSpacing.constant = 0
            
            articles = cachedStories
            newsTable.reloadData()
            view.endEditing(true)//hide keyboard
        }
    }
    
    func textFieldDidChange(textField: UITextField) {
        print(textField.text?.characters.count)
        if textField.text?.characters.count > 0 {
            APIManager.searchArticles(textField.text!, completion: {
                articles in
                self.articles = articles
                self.newsTable.reloadData()
            })
        }
    }
    
    func clearSearch() {
        searchBar.searchTextField.text = ""
    }
    
    //MARK: tabBar delegate
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        //TODO: go to controller..
    }
    
    
}

