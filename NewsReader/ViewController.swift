//
//  ViewController.swift
//  NewsReader
//
//  Created by Song Liao on 6/1/16.
//  Copyright © 2016 Song. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var newsTable: UITableView!

    var articles = [Article]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let a = Article()
        a.title = "This is author A"
        
        let b = Article()
        b.title = "This is author title B"
        articles.append(a)
        articles.append(b)
        
        newsTable.separatorInset = UIEdgeInsets(top: 0, left: 84, bottom: 0, right: 0)
        newsTable.tableFooterView = UIView(frame: CGRectZero)
    }

       
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NewsCell", forIndexPath: indexPath) as! NewsCell
        
    
        cell.titleLabel.text = articles[indexPath.row].title
        cell.likesLabel.text = String(arc4random_uniform(50))
        cell.commentsLabel.text = String(arc4random_uniform(20))
        return cell
     }


    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 85
    }
}

