//
//  EmptyTableViewCell.swift
//  JJUNGTABLE
//
//  Created by Sean Kim on 10/30/23.
//

import UIKit

class EmptyTableViewCell: UITableViewCell {

    @IBOutlet weak var emptyLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
