//
//  ViewController.swift
//  NewsReader
//
//  Created by Song Liao on 6/1/16.
//  Copyright © 2016 Song. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var searchButton: UIBarButtonItem!
    
    @IBOutlet weak var newsTableTopSpacing: NSLayoutConstraint!
    
    @IBOutlet weak var searchBar: SearchBar!
    
    let tableViewImageDimension: CGFloat = 85
    
    @IBOutlet weak var newsTable: UITableView!
    var articles = [Article]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSearchBar()
        styleSearchBar()
        
        //
//        APIManager.searchArticles("Bieber", completion: {
//            articles in
//            self.articles = articles
//            self.newsTable.reloadData()
//        })
        APIManager.getTopStories(completion: {
            articles in
            self.articles = articles
            self.newsTable.reloadData()
        })
    }

    private func setUpSearchBar() {
        newsTable.separatorInset = UIEdgeInsets(top: 0, left: tableViewImageDimension-1, bottom: 0, right: 0)
        newsTable.tableFooterView = UIView(frame: CGRectZero)//no separator for empty cells
    }
    
    private func styleSearchBar() {
        searchBar.searchTextField.borderStyle = .RoundedRect
        searchBar.searchTextField.addTarget(self, action: #selector(ViewController.textFieldDidChange(_:)), forControlEvents: UIControlEvents.EditingChanged)
        searchBar.clearSearchButton.addTarget(self, action: #selector(ViewController.clearSearch), forControlEvents: .TouchUpInside)
       
    }
       
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


    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableViewImageDimension
    }
    
    //search bar related
    @IBAction func searchButtonClicked(sender: UIBarButtonItem) {
      
        if searchBar.hidden { //if hidden show search bar
            searchBar.hidden = false
            searchButton.image = UIImage(named : "ic_close")
            newsTableTopSpacing.constant = 56
        } else { //hide search bar
            searchBar.hidden = true
             searchButton.image = UIImage(named : "ic_search")
            newsTableTopSpacing.constant = 0
        }
    }
    
    func textFieldDidChange(textField: UITextField) {
        print(textField.text)
    }
    
    func clearSearch() {
        searchBar.searchTextField.text = ""
    }
}

