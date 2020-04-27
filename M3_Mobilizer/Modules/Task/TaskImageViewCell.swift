//
//  TaskImageViewCell.swift
//  M3_Mobilizer
//
//  Created by Happy Sanz Tech on 30/01/20.
//  Copyright © 2020 Happy Sanz Tech. All rights reserved.
//

import UIKit

class TaskImageViewCell: UITableViewCell {

    @IBOutlet weak var taskImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
