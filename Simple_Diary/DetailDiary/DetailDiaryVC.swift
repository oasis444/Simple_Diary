//
//  DetailDiaryVC.swift
//  Simple_Diary
//
//  Copyright (c) 2023 oasis444. All right reserved.
//

import UIKit

protocol DiaryDetailViewDelegate: AnyObject {
    func didSelectDelete(indexPath: IndexPath)
    func didSelectBookMark(indexpath: IndexPath, bookMark: Bool)
}

class DetailDiaryVC: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    
    weak var delegate: DiaryDetailViewDelegate?
    var diary: Diary?
    var indexPath: IndexPath?
    private var bookMarkBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    @IBAction func tapEditBtn(_ sender: UIButton) {
        guard let diary = diary else { return }
        guard let indexPath = indexPath else { return }
        let sb = UIStoryboard(name: "WriteDiary", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "WriteDiaryVC") as! WriteDiaryVC
        vc.diaryEditMode = .edit(indexPath, diary)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(editDiaryNotification(_:)),
            name: NSNotification.Name("editDiary"),
            object: nil
        )
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func editDiaryNotification(_ notification: Notification) {
        guard let diary = notification.object as? Diary else { return }
        self.diary = diary
        self.configure()
    }
    
    @IBAction func tapDeleteBtn(_ sender: UIButton) {
        guard let indexPath = indexPath else { return }
        delegate?.didSelectDelete(indexPath: indexPath)
        navigationController?.popViewController(animated: true)
    }
    
    private func configure() {
        guard let diary = diary else { return }
        bookMarkBtn = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(tapBookMarkBtn))
        bookMarkBtn.image = diary.bookMark ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        bookMarkBtn.tintColor = .systemOrange
        navigationItem.rightBarButtonItem = bookMarkBtn
        titleLabel.text = diary.title
        contentsTextView.text = diary.contents
        dateLabel.text = CalcDate().dateToString(date: diary.date)
    }
    
    @objc func tapBookMarkBtn() {
        guard let bookMark = diary?.bookMark else { return }
        guard let indexPath = indexPath else { return }
        bookMarkBtn.image = bookMark ? UIImage(systemName: "star") : UIImage(systemName: "star.fill")
        diary?.bookMark = !bookMark
        delegate?.didSelectBookMark(indexpath: indexPath, bookMark: diary?.bookMark ?? false)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
