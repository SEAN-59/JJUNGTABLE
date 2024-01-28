//
//  TopView.swift
//  JJUNGTABLE
//
//  Created by Sean Kim on 10/29/23.
//

import UIKit

class TopView: BaseView {
    weak var delegate: topButtonDelegate?

    @IBOutlet weak var firstBtn: UICustomButton!
    @IBOutlet weak var secondBtn: UICustomButton!
    @IBOutlet weak var thirdBtn: UICustomButton!
    @IBOutlet weak var fourthBtn: UICustomButton!
    @IBOutlet weak var fifthBtn: UICustomButton!
    
    @IBOutlet weak var firstCircleImg: UIImageView!
    @IBOutlet weak var secondCircleImg: UIImageView!
    @IBOutlet weak var thirdCircleImg: UIImageView!
    @IBOutlet weak var forthCircleImg: UIImageView!
    
    override func viewLoad() {
    }
    
    func toggleCircleHidden(is1stHidden: Bool = T, is2ndHidden: Bool = T, is3rdHidden: Bool = T, is4thHidden: Bool = T) {
        self.firstCircleImg.isHidden = is1stHidden
        self.secondCircleImg.isHidden = is2ndHidden
        self.thirdCircleImg.isHidden = is3rdHidden
        self.forthCircleImg.isHidden = is4thHidden
    }
    
    /// Default = title 보여주고 나머지는 감춤
    func changeBtnHidden(isTitleHidden: Bool = F ,is1stHidden: Bool = T, is2ndHidden: Bool = T, is3rdHidden: Bool = T, is4thHidden: Bool = T) {
        self.firstBtn.isHidden = isTitleHidden
        self.secondBtn.isHidden = is1stHidden
        self.thirdBtn.isHidden = is2ndHidden
        self.fourthBtn.isHidden = is3rdHidden
        self.fifthBtn.isHidden = is4thHidden
    }
    
    func changeBtnImage(_ num: Int, img: UIImage?) {
        let arrayBtn: [UICustomButton] = [self.firstBtn,self.secondBtn,self.thirdBtn,self.fourthBtn,self.fifthBtn]
        if img != nil { arrayBtn[num].setImage(img, for: .normal) }
    }
    
    @IBAction func tapTopBtn(_ sender: UICustomButton) {
        switch sender.tag {
        case 0:
            self.delegate?.tapTopButton(.firstBtn)
        case 1:
            self.delegate?.tapTopButton(.secondBtn)
        case 2:
            self.delegate?.tapTopButton(.thirdBtn)
        case 3:
            self.delegate?.tapTopButton(.forthBtn)
        case 4:
            self.delegate?.tapTopButton(.fifthBtn)
        default:
            self.delegate?.tapTopButton(.error)
        }
    }
    
}
