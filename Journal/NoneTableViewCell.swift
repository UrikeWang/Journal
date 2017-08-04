//
//  NoneTableViewCell.swift
//  Journal
//
//  Created by yuling on 2017/8/4.
//  Copyright © 2017年 yuling. All rights reserved.
//

import UIKit

class NoneTableViewCell: UITableViewCell {

    @IBOutlet weak var noneJournalLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
