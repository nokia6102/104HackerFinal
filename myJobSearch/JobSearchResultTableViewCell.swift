//
//  JobSearchResultTableViewCell.swift
//  myJobSearch
//
//  Created by chang on 2017/7/21.
//  Copyright © 2017年 chang. All rights reserved.
//

import UIKit

class JobSearchResultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
