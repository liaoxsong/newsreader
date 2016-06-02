//
//  TestView.swift
//  NewsReader
//
//  Created by Song Liao on 6/1/16.
//  Copyright © 2016 Song. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class TestView: UITextView {
    
    override func drawRect(rect: CGRect) {
        
        //let bannerText = UITextView(frame: CGRect(x: 0, y:0, width: rect.width, height: 100))
        self.backgroundColor = UIColor.navigationGreyColor()
        self.text = Constants.BANNERTEXT
        self.textColor = UIColor.lightGrayColor()
        self.font = UIFont.italicSystemFontOfSize(13)
        self.editable = false
        self.textContainerInset = UIEdgeInsets(top: 8, left: 15, bottom: 8, right: 15)
        self.sizeToFit()

    }
}