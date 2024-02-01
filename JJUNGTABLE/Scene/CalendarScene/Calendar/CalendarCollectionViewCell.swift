//
//  CalendarCollectionViewCell.swift
//  JJUNGTABLE
//
//  Created by Sean Kim on 12/1/23.
//

import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {
    weak var delegate: CellDelegate?
    private var cellDay = CalendarDay(F)
    private var disableCell = F
    
    // Cell 선택 관련
    private var isToggleCell = F
    private var toggleState = F
    private var indexPath: IndexPath?
    
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var dayLbl: UILabel!
    
    override var isSelected: Bool {
        didSet {
            if !self.disableCell {
                if self.isSelected {
                    if self.cellDay.day != -1 {
                        if self.isToggleCell {
                            self.toggleState.toggle()
                            self.toggleCellDraw()
                            if let indexPath = self.indexPath {
                                self.delegate?.sendTapCellInfo(indexPath)
                            }
                        }
                        
                        let data = (self.cellDay, self.toggleState)
                        self.delegate?.sendCellData(data)
                    }
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.lineView.layer.borderColor = UIColor.black.cgColor
        self.lineView.layer.borderWidth = 1.5
        self.lineView.layer.cornerRadius = 10.0
        self.backView.layer.cornerRadius = 10.0
    }
    
    override func prepareForReuse() {
        printLog("WHAT?")
        self.toggleState = F
        self.disableCell = F
    }
    
    //MARK: PUBLIC FUNC
    
    func setData(_ day: CalendarDay, today: Bool, isToggleCell: Bool, indexPath: IndexPath) {        
        self.cellDay = day
        self.isToggleCell = isToggleCell
        self.indexPath = indexPath
        
        if self.cellDay.day == -1 { self.dayLbl.text = "" }
        else { self.dayLbl.text = "\(self.cellDay.day)" }
        
        if self.cellDay.dayOfWeek == 0 { self.dayLbl.textColor = .systemRed }
        else if self.cellDay.dayOfWeek == 6 { self.dayLbl.textColor = .systemBlue }
        else {
            if today { self.dayLbl.textColor = .greenColor }
            else { self.dayLbl.textColor = .label }
        }
        
        self.drawCell(self.cellDay.day, today)
    }
    
    func changeDisableCell() {
        self.disableCell = T
        self.dayLbl.textColor = .lightGray
        self.backView.backgroundColor = .lightGray.withAlphaComponent(0.2)
    }
    
    func turnOffCell() {
        if self.isToggleCell {
            if self.toggleState {
                self.toggleState.toggle()
                self.toggleCellDraw()
            }
        }
    }
    
    
    //MARK: PRIVATE FUNC
    
    private func drawCell(_ cellDay: Int, _ today: Bool) {
        if cellDay == -1 {
            self.backView.backgroundColor = .lightGray.withAlphaComponent(0.2)
            self.lineView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.2).cgColor
            self.lineView.layer.borderWidth = 1.0
        }
        else {
            self.backView.backgroundColor = .brandColor.withAlphaComponent(0.2)
            self.lineView.layer.borderColor = UIColor.black.cgColor
            self.lineView.layer.borderWidth = 1.5
        }
        
        if today { self.backView.backgroundColor = .greenColor.withAlphaComponent(0.2) }
        
    }
    
    
    
    private func toggleCellDraw() {
        if toggleState {
            self.backView.backgroundColor = self.backView.backgroundColor?.withAlphaComponent(0.6)
        }
        else {
            self.backView.backgroundColor = self.backView.backgroundColor?.withAlphaComponent(0.2)
        }
    }

    
    
}
