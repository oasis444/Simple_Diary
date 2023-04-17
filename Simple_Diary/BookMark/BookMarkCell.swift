//
//  BookMarkCell.swift
//  Simple_Diary
//
//  Copyright (c) 2023 oasis444. All right reserved.
//

import UIKit

class BookMarkCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    func configure(info: Diary) {
        titleLabel.text = info.title
        dateLabel.text = CalcDate().dateToString(date: info.date)
    }
}
