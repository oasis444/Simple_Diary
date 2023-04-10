//
//  DiaryVC.swift
//  Simple_Diary
//
//  Copyright (c) 2023 oasis444. All right reserved.
//

import UIKit

class DiaryVC: UIViewController, WriteDiaryViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var diaryList = [Diary]()
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
        let sb = UIStoryboard(name: "DiaryDetail", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "DiaryDetailVC") as! DiaryDetailVC
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func didSelectRegister(diary: Diary) {
        diaryList.append(diary)
        applyItems(items: diaryList)
    }
}

extension DiaryVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("select: \(indexPath.item)")
    }
}
