//
//  HomeViewController.swift
//  DYZB
//
//  Created by apple on 2019/04/27.
//  Copyright © 2019年 com.btx. All rights reserved.
//

import UIKit

private let kTitleViewH : CGFloat = 40

class HomeViewController: UIViewController {

    // 懒加载属性
    private lazy var pageTitleView : PageTitleView = {[weak self] in
        let titleFrame = CGRect(x: 0, y: kStatusBarH + kNavgationBarH, width: kScreenW, height: kTitleViewH)
        let titles = ["進め","ゲーム","遊ぶ","趣味"]
        let titleView = PageTitleView(frame:titleFrame, titles:titles)
        //HomeはtitleViewの代理にさせる
        titleView.delegate = self
        return titleView
    }()
    
    private lazy var pageContentView : PageContentView = {[weak self] in
        // 1.内容のframe確認編集
        let contentH = kScreenH - kStatusBarH - kNavgationBarH - kTitleViewH - kTabBarH
        let contentFrame = CGRect(x: 0, y: kStatusBarH + kNavgationBarH + kTitleViewH, width: kScreenW, height: contentH)
        
        // 2.全部の子コントロールを確定する
        var childVcs = [UIViewController]()
        childVcs.append(RecommendViewController())
        for _ in 0..<3 {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor(r : CGFloat(arc4random_uniform(255)), g : CGFloat(arc4random_uniform(255)), b : CGFloat(arc4random_uniform(255)))
            childVcs.append(vc)
        }
        
        let contentView = PageContentView(frame: contentFrame, childVcs: childVcs, parentViewController: self)
        //HomeはcontentViewの代理にさせる
        contentView.delegate = self
        return contentView
    }()
    
    // system callback函数
    override func viewDidLoad() {
        super.viewDidLoad()

        // UIレイアウト設定
        setupUI()
    }

}

// MARK:- UIレイアウト設定
extension HomeViewController{
    private func setupUI(){
        // 0.UIScrollViewのpaddingを調整する必要がない
        automaticallyAdjustsScrollViewInsets = false
        
        // 1.ナビセット
        setupNavigationBar()
        
        // 2.TitleView追加
        view.addSubview(pageTitleView)
        
        // 3.PageContentView追加
        view.addSubview(pageContentView)

    }
    
    private func setupNavigationBar(){
        
        // 1.上左の項目設定
        navigationItem.leftBarButtonItem = UIBarButtonItem(imageName: "logo")
        
        // 2.上右の項目設定
        let size = CGSize(width: 40, height: 40)
        
        let historyItem = UIBarButtonItem.createItem(imageName: "image_my_history",highImageName: "Image_my_history_click", size: size)
        
        let searchItem = UIBarButtonItem.createItem(imageName: "btn_search", highImageName: "btn_search_clicked", size: size)

        let qrcodeItem = UIBarButtonItem(imageName: "Image_scan", highImageName: "Image_scan_click", size: size)
        
        navigationItem.rightBarButtonItems = [historyItem, searchItem, qrcodeItem]
    }
    
}

// MARK:- PageTitleViewの代理契約を守る
extension HomeViewController : PageTitleViewDelegate{
    func pageTitleView(titleView: PageTitleView, selectIndex index: Int) {
        pageContentView.setCurrentIndex(currentIndex: index)
    }
}

// MARK:- PageContentViewの代理契約を守る
extension HomeViewController : PageContentViewDelegate{
    func pageContentView(contentView: PageContentView, progess: CGFloat, sourceIndex: Int, targetIndex: Int) {
        pageTitleView.setPageTitleProgress(progress: progess, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}
