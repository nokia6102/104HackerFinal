//
//  ChannelListTableViewCell.swift
//  myJobSearch
//
//  Created by chang on 2017/7/29.
//  Copyright © 2017年 chang. All rights reserved.
//

import UIKit

class ChannelListTableViewCell: UITableViewCell {

    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblChat: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
