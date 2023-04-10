//
//  Diary.swift
//  Simple_Diary
//
//  Copyright (c) 2023 oasis444. All right reserved.
//

import Foundation

struct Diary: Hashable {
    var title: String
    var contents: String
    var date: Date
    var bookMark: Bool
}

class CalcDate {
    func dateToString(date: Date, type: String? = nil) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = type ?? "yy년 MM월 dd일(EEEEE)"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
}
