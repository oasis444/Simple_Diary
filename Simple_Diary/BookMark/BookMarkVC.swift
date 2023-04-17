//
//  BookMarkVC.swift
//  Simple_Diary
//
//  Copyright (c) 2023 oasis444. All right reserved.
//

import UIKit

class BookMarkVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private var diaryList = [Diary]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadBookMarkList()
    }
    
    private func configCollectionView() {
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func loadBookMarkList() {
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.object(forKey: "diaryList") as? [[String: Any]] else { return }
        diaryList = data.compactMap {
            guard let title = $0["title"] as? String else { return nil }
            guard let contents = $0["contents"] as? String else { return nil }
            guard let date = $0["date"] as? Date else { return nil }
            guard let bookMark = $0["bookMark"] as? Bool else { return nil }
            return Diary(title: title, contents: contents, date: date, bookMark: bookMark)
        }.filter { $0.bookMark == true }.sorted(by: { prev, next in
            prev.date > next.date
        })
        collectionView.reloadData()
    }
}

extension BookMarkVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return diaryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookMarkCell", for: indexPath) as? BookMarkCell else { return UICollectionViewCell() }
        let diary = diaryList[indexPath.item]
        cell.configure(info: diary)
        return cell
    }
}

extension BookMarkVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 20
        let height = CGFloat(80)
        return CGSize(width: UIScreen.main.bounds.width, height: height)
    }
}
