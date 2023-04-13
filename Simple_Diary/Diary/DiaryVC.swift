//
//  DiaryVC.swift
//  Simple_Diary
//
//  Copyright (c) 2023 oasis444. All right reserved.
//

/*
 info: 아래 코드에서 viewDidLoad 할 때마다 UserDefaults로 저장된 값을 불러오고 diaryList에 저장하면 didSet에 의해 다시 저장하게 되어 비효율적이지만 didSet의 활용을 보여주기 위해 사용한 방법
 */

import UIKit

class DiaryVC: UIViewController, WriteDiaryViewDelegate, DiaryDetailViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var diaryList = [Diary]() {
        didSet {
            self.saveDiaryList()
        }
    }
    let userDefaults = UserDefaults.standard
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    typealias Item = Diary
    enum Section {
        case main
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
        configureCollectionView()
    }
    
    private func configure() {
        let addBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAction))
        navigationItem.rightBarButtonItem = addBtn
        
        guard let diarys = userDefaults.object(forKey: "diaryList") as? [[String: Any]] else { return }
        let diarylist = diarys.map {
            let title = $0["title"] as! String
            let contents = $0["contents"] as! String
            let date = $0["date"] as! Date
            let bookMark = $0["bookMark"] as! Bool
            return Diary(title: title, contents: contents, date: date, bookMark: bookMark)
        }
        diaryList = sorting(list: diarylist)
    }
    
    private func configureCollectionView() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiaryCell", for: indexPath) as? DiaryCell else { return nil }
            cell.configure(info: itemIdentifier)
            return cell
        })
        collectionView.collectionViewLayout = layout()
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(diaryList)
        dataSource.apply(snapshot)
        
        collectionView.delegate = self
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.49), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .estimated(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .flexible(5)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        section.interGroupSpacing = 10
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func applyItems(items: [Diary]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        dataSource.apply(snapshot)
    }

    @objc func addAction() {
        let sb = UIStoryboard(name: "WriteDiary", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "WriteDiaryVC") as! WriteDiaryVC
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func didSelectRegister(diary: Diary) {
        diaryList.append(diary)
        diaryList = sorting(list: diaryList)
        applyItems(items: diaryList)
    }
    
    func didSelectDelete(indexPath: IndexPath) {
        diaryList.remove(at: indexPath.item)
        applyItems(items: diaryList)
    }
    
    private func saveDiaryList() {
        let diarys: [[String: Any]] = diaryList.map {
            [
                "title": $0.title,
                "contents": $0.contents,
                "date": $0.date,
                "bookMark": $0.bookMark
            ]
        }
        userDefaults.set(diarys, forKey: "diaryList")
    }
    
    private func sorting(list: [Diary]) -> [Diary] {
        let sortedList = list.sorted { prev, next in
            prev.date > next.date
        }
        return sortedList
    }
}

extension DiaryVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "DetailDiary", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "DetailDiaryVC") as! DetailDiaryVC
        vc.diary = diaryList[indexPath.item]
        vc.indexPath = indexPath
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
}
