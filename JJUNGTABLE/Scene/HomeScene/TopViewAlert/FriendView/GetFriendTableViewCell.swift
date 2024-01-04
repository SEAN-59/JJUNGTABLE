//
//  GetFriendTableViewCell.swift
//  JJUNGTABLE
//
//  Created by Sean Kim on 11/28/23.
//

import UIKit

class GetFriendTableViewCell: UITableViewCell {
    weak var delegate: CellDelegate?
    
    private var cellData: GetFriendData = .init(id: "", name: "", tableId: "")
    private var cellIndex: IndexPath = []
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var friendNameLbl: UILabel!
    @IBOutlet weak var acceptBtn: UICustomButton!
    @IBOutlet weak var refuseBtn: UICustomButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setLayout()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    private func setLayout(){
        self.profileImg.layer.cornerRadius = 10.0
        self.profileImg.layer.borderColor = UIColor.black.cgColor
        self.profileImg.backgroundColor = .backColor
        [
            self.acceptBtn, self.refuseBtn
        ].forEach {
            $0.layer.borderColor = $0.titleColor(for: .normal)?.cgColor
            $0.layer.borderWidth = 2.0
            $0.layer.cornerRadius = 15.0
        }
    }
    
    func setData(_ data: GetFriendData, index: IndexPath) {
        self.cellData = data
        self.cellIndex = index
        self.friendNameLbl.text = self.cellData.name
    }
    
    @IBAction func tapBtn(_ sender: UICustomButton) {
        @UserDefault(key: "loginId", defaultValue: "") var loginId
        // 수락
        if sender.tag == 0 {
            // friends에 친구 tableId 추가
            DatabaseManager().updateDataBase(.friends, key: "\(loginId)/\(self.cellData.tableId)", data: "") { _ in }
//            self.dbManager.updateData(.friends, key: "\(loginId)/\(self.cellData.tableId)", data: "")
        }
        // 거절
        else if sender.tag == 1 {
            // getFriend에서 친구 tableId 삭제
            DatabaseManager().deleteDataBase(.getFriend, key: "\(loginId)/\(self.cellData.tableId)") { _ in }
//            self.dbManager.deleteData(.getFriend, key: "\(loginId)/\(self.cellData.tableId)")
        }
    }
}
