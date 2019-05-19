//
//  RecommendViewController.swift
//  DYZB
//
//  Created by apple on 2019/05/06.
//  Copyright © 2019年 com.btx. All rights reserved.
//

import UIKit

private let kItemMargin : CGFloat = 10
private let kItemW = (kScreenW - 3 * kItemMargin) / 2
private let kitemH = kItemW * 3/4
private let kPrettyItemH = kItemW * 4/3
private let kHeaderViewH : CGFloat = 50

private let kNormalCellID = "kNormalCellID"
private let kPrettyCellID = "kPrettyCellID"
private let kHeaderViewID = "kHeaderViewID"

class RecommendViewController: UIViewController {
    
    //懒加载属性
    private lazy var collectionView : UICollectionView = {[unowned self] in
        // 1.流水式layout作成
        let layout = UICollectionViewFlowLayout()
        //contentCellのサイズは代理の中で動的に制御する
        //layout.itemSize = CGSize(width: kItemW, height: kitemH)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = kItemMargin
        layout.headerReferenceSize = CGSize(width: kScreenW, height: kHeaderViewH)
        layout.sectionInset = UIEdgeInsets(top: 0, left: kItemMargin, bottom: 0, right: kItemMargin)
        
        // 2.CollectionView作成
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        //viewのboundsの変化により、collectionViewのサイズを自動的に調整する
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        // 3.各種別のセルのregist
        // 3.1.内容セルのregist
        collectionView.register(UINib(nibName: "CollectionNormalCell", bundle: nil), forCellWithReuseIdentifier: kNormalCellID)
        collectionView.register(UINib(nibName: "CollectionPrettyCell", bundle: nil), forCellWithReuseIdentifier: kPrettyCellID)
        // 3.2.内容のカテゴリーセルのregist nibNameはCollectionHeaderView.xib
        collectionView.register(UINib(nibName: "CollectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kHeaderViewID)
        
        return collectionView
    }()

    // system callback函数
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // UIレイアウト設定
        setupUI()
    }

}

// MARK:- UIレイアウト設定
extension RecommendViewController{
    private func setupUI(){
        // 1.UICollectionViewを追加して
        view.addSubview(collectionView)
    }
}

// MARK:- CollectionView.DataSourceの協議を守る
// MARK:- UICollectionViewDelegateFlowLayout代理でcontentCellのサイズは動的に制御する
extension RecommendViewController : UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            return 8
        }
        
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 1.cell取得
        //let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kNormalCellID, for: indexPath)
        //cell.backgroundColor = UIColor.black
        
        // 1.cell定義
        var cell : UICollectionViewCell!
        // 2.cell取得
        if indexPath.section == 1 {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: kPrettyCellID, for: indexPath)
        }else{
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: kNormalCellID, for: indexPath)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        // sectionのheadView取得
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kHeaderViewID, for: indexPath)
        
        return headerView
    }
    
    //contentCellのサイズは代理の中で動的に制御する
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 1{
            return CGSize(width: kItemW, height: kPrettyItemH)
        }
        
        return CGSize(width: kItemW, height: kitemH)
    }
}
