//
//  FeedTableViewCell.swift
//  AHNewsFeed
//
//  Created by Ara Hakobyan on 12/12/2017.
//  Copyright © 2017 Ara Hakobyan. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
        
    func setup(with item: Feed) {
        thumbImageView.download(image: URL(string: item.thumbnail))
        categoryLabel.text = item.pillarName + " (" + item.sectionName + ")"
        titleLabel.text = item.webTitle
    }
}
