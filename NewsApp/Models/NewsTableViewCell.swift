//
//  NewsTableViewCell.swift
//  NewsApp
//
//  Created by Nikolas Omelianov on 31.05.2018.
//  Copyright © 2018 Nikolas Omelianov. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var cellRelease: UILabel!
    @IBOutlet weak var cellRating: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
   
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
