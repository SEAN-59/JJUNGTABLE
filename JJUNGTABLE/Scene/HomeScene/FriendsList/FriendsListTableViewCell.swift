//
//  FriendsListTableViewCell.swift
//  JJUNGTABLE
//
//  Created by Sean Kim on 10/30/23.
//

import UIKit
import SnapKit

class FriendsListTableViewCell: UITableViewCell {
    private var friendData = FriendData(id: "", name: "", isSwitch: "", tableId: "", state: "")
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var stateLbl: UILabel!
    @IBOutlet weak var isReserveLbl: UILabel!
    
    @IBOutlet weak var profileImg: UIImageView!
    
    @IBOutlet weak var checkPlanBtn: UICustomButton!
    @IBOutlet weak var reservationBtn: UICustomButton!
    
    // 만약 배경색을 바꾸게 된다면 얘도 색상 바꿔야 함
    private lazy var whiteView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 15.0
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func delete(_ sender: Any?) {
        printLog("DELETE?\(self.friendData.name)")
    }
    
    func setData(_ data: FriendData) {
        self.friendData = data
        self.setLayOut()
    }
    
    private func setLayOut() {
        self.profileImg.layer.cornerRadius = 10.0
        self.profileImg.layer.borderColor = UIColor.black.cgColor
        self.profileImg.backgroundColor = .backColor
        
        self.nameLbl.text = "\(self.friendData.name)"
        self.stateLbl.text = self.friendData.state == nil ? "":"\(String(describing: self.friendData.state))"
//
        if self.friendData.isSwitch == "Y" {
            self.isReserveLbl.text = "가능"
            self.isReserveLbl.textColor = .greenColor
            [self.reservationBtn,self.checkPlanBtn].forEach{
                $0.animateBig = true
                $0.setTitleColor(.black, for: .normal)
                $0.layer.borderColor = UIColor.black.cgColor
                $0.layer.borderWidth = 2
                $0.layer.cornerRadius = 25
            }
        } else {
            self.isReserveLbl.text = "불가"
            self.isReserveLbl.textColor = .brandColor
        
            [self.reservationBtn,self.checkPlanBtn].forEach{
                $0.animateBig = false
                $0.setTitleColor(.systemGray3, for: .normal)
                $0.layer.borderColor = UIColor.systemGray3.cgColor
                $0.layer.borderWidth = 2
                $0.layer.cornerRadius = 25
            }
        }
        self.toggleIndicator(false)
    }
    
    func toggleIndicator(_ flag: Bool) {
        if flag {
            self.addSubview(self.whiteView)
            self.whiteView.snp.updateConstraints{
                $0.edges.equalToSuperview()
            }
            self.showIndicator(removeBack: true)
        }
        else {
            self.whiteView.removeFromSuperview()
            self.stopIndicator()
        }
    }
    
    @IBAction func tapFriendBtn(_ sender: UICustomButton) {
        if self.friendData.isSwitch == "Y" {
            let nextVC = FriendPopUpViewController(nibName: "FriendPopUpViewController", bundle: nil)
            if sender.tag == 0 {
                nextVC.sendData("calendar", friendId: friendData.id)
            }
            else if sender.tag == 1 {
                nextVC.sendData("reserve",friendId: "")
            }
            
            if let vc = viewControllers.last as? MainViewController {
                vc.presentVC(fromVC: vc,
                             nextVC: nextVC,
                             modalStyle: .automatic,
                             presentAnimate: T)
            }
            
        }
        
        
    }
}
