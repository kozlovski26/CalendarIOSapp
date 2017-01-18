//
//  MyEventsTableViewCell.swift
//  Project
//
//  Created by admin on 01/01/2017.
//  Copyright © 2017 admin. All rights reserved.
//

import UIKit

class MyEventsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var stTitle: UILabel!
    @IBOutlet weak var stDate: UILabel!
    @IBOutlet weak var stImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
