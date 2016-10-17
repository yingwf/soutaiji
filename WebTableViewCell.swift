//
//  WebTableViewCell.swift
//  SouTaiji
//
//  Created by  ywf on 16/9/25.
//  Copyright © 2016年  ywf. All rights reserved.
//

import UIKit

class WebTableViewCell: UITableViewCell {

    static let id = "WebTableViewCell"
    
    @IBOutlet weak var webView: UIWebView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func dataBind(content: String) {
        
        webView.loadHTMLString(content, baseURL: nil)
        webView.sizeToFit()
        
    }
    
}
