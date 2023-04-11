//
//  DiaryCell.swift
//  Simple_Diary
//
//  Copyright (c) 2023 oasis444. All right reserved.
//

import UIKit

class DiaryCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 3
    }
    
    func configure(info: Diary) {
        titleLabel.text = info.title
        dateLabel.text = CalcDate().dateToString(date: info.date)
    }
}
