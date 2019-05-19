//
//  PageContentView.swift
//  DYZB
//
//  Created by apple on 2019/05/02.
//  Copyright © 2019年 com.btx. All rights reserved.
//

import UIKit

protocol PageContentViewDelegate : class{
    func pageContentView(contentView : PageContentView, progess : CGFloat, sourceIndex : Int, targetIndex : Int)
}

private let ContentCellID = "ContentCellID"

class PageContentView: UIView {
    
    // 属性定義
    private var childVcs : [UIViewController]
    private weak var parentViewController : UIViewController?
    private var startOffsetX : CGFloat = 0
    private var isForbidScrollDelegate : Bool = false
    weak var delegate : PageContentViewDelegate?
    
    //懒加载属性
    private lazy var collectionView : UICollectionView = {[weak self] in
        // 1.流水式layout作成
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)! //選択可能タイプは()!で解除包
        layout.minimumLineSpacing = 0 //行間距離
        layout.minimumInteritemSpacing = 0 //項目間距離
        layout.scrollDirection = .horizontal
        
        // 2.CollectionView作成
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout : layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.scrollsToTop = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ContentCellID)
        
        return collectionView
        
    }()
    
    // 自定義構造函数
    init(frame: CGRect, childVcs : [UIViewController], parentViewController : UIViewController?) {
        self.childVcs = childVcs
        self.parentViewController = parentViewController
        
        super.init(frame : frame)
        
        // UIレイアウト設定
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:- UIレイアウト設定
extension PageContentView{
    private func setupUI(){
        // 1.全部の子コントロールを親コントロールに追加する
        for childVc in childVcs {
            parentViewController?.addChild(childVc)
        }
        
        // 2.UICollectionViewを追加して、cellの中でコントロールのviewを放置する用
        addSubview(collectionView)
        collectionView.frame = bounds
    }
}

// MARK:- CollectionView.DataSourceの協議を守る
extension PageContentView : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 1.Cell取得
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCellID, for: indexPath)
        
        // 2.Cell内容設定
        for view in cell.contentView.subviews{
            view.removeFromSuperview()
        }
        
        let childVc = childVcs[indexPath.item]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        
        return cell
    }
}

// MARK:- UICollectionViewDelegateの協議を守る
// 計算論理さ参考：ios Swift開発項目　DYZBapp 12課
extension PageContentView : UICollectionViewDelegate{
    
    //dragの時に偏移量を取る
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //contentのdrag操作の際、PageContentViewの代理を起動する
        isForbidScrollDelegate = false
        
        startOffsetX = scrollView.contentOffset.x
    }
    
    //drag操作をけ監視する
    func scrollViewDidScroll(_ scrollView : UIScrollView){
        // 0.titleLabelのクリックイベントかどうかを判断する
        if isForbidScrollDelegate == true{return}
        
        // 1.データ取得
        var progress : CGFloat = 0 //dragの比例
        var sourceIndex : Int = 0  //drag元
        var targetIndex : Int = 0  //drag先
        
        // 2.drag左右方向判断
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.bounds.width
        if currentOffsetX > startOffsetX { // 左移
            // 1.計算progress
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)
            
            // 2.計算sourceIndex
            sourceIndex = Int(currentOffsetX / scrollViewW)
            
            // 3.計算targetIndex
            targetIndex = sourceIndex + 1
            if targetIndex >= childVcs.count{
                targetIndex = childVcs.count - 1
            }
            
            // ４.移動完成
            if currentOffsetX - startOffsetX == scrollViewW{
                progress = 1
                targetIndex = sourceIndex
            }
        }else{ // 右移
            // 1.計算progress
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))
            
            // 2.計算targetIndex
            targetIndex = Int(currentOffsetX / scrollViewW)
            
            // 3.計算sourceIndex
            sourceIndex = targetIndex + 1
            if sourceIndex >= childVcs.count{
                sourceIndex = childVcs.count - 1
            }
        }
        
        // 3.代理通知の方式でtitleViewにパラメタを渡す
        delegate?.pageContentView(contentView: self, progess: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}

// MARK:- 外部に提供する方法
extension PageContentView{
    //title選択によりcontentを切り替える
    func setCurrentIndex(currentIndex : Int) {
        //titleLabelのクリック操作の際、PageContentViewの代理を禁止する
        isForbidScrollDelegate = true
        
        //pageCotent移動
        let offsetX = CGFloat(currentIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x: offsetX, y : 0), animated: false)
    }
}
