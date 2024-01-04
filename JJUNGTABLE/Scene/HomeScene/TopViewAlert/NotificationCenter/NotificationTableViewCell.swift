//
//  NotificationTableViewCell.swift
//  JJUNGTABLE
//
//  Created by Sean Kim on 11/19/23.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var contentMainView: UIView!
    
    @IBOutlet weak var pushNameLbl: UILabel!
    @IBOutlet weak var pushDataLbl: UILabel!
    @IBOutlet weak var pushTimeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.contentMainView.layer.borderWidth = 1
        self.contentMainView.layer.cornerRadius = 15
        self.contentMainView.backgroundColor = UIColor.brandColor?.withAlphaComponent(0.025)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        printLog("SELECT NOTI CELL")
        // Configure the view for the selected state
    }
    
}

