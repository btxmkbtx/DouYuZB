//
//  PageTitleView.swift
//  DYZB
//
//  Created by apple on 2019/04/30.
//  Copyright © 2019年 com.btx. All rights reserved.
//

import UIKit

// 代理契約定義　：classしか使えないように限定する
protocol PageTitleViewDelegate : class {
    func pageTitleView(titleView : PageTitleView, selectIndex index : Int)
}

// 定数
private let kScrollLineH : CGFloat = 2
private let kNormalColor : (CGFloat, CGFloat, CGFloat) = (85, 85, 85)
private let kSelectColor : (CGFloat, CGFloat, CGFloat) = (255, 128, 0)

// クラス
class PageTitleView: UIView {
    
    // 属性定義
    private var currentIndex : Int = 0
    private var titles : [String]
    weak var delegate : PageTitleViewDelegate?
    
    //懒加载属性
    private lazy var titleLabels : [UILabel] = [UILabel]()
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        return scrollView
    }()
    private lazy var scrollLine : UIView = {
        let scrollLine = UIView()
        scrollLine.backgroundColor = UIColor.orange
        return scrollLine
    }()
    
    // 自定義構造函数
    init(frame: CGRect, titles : [String]) {
        self.titles = titles
        
        super.init(frame : frame)
        
        // UIレイアウト設定
        setupUI()
    }
    
    // 自定義構造函数を使う時で、このメソッドを実装しないといけない
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//UIレイアウト設定
extension PageTitleView{
    private func setupUI(){
        // 1.scrollView追加
        addSubview(scrollView)
        scrollView.frame = bounds //frameに当前viewのboundsを指定する
        
        // 2.titleに対するlabelを追加する
        setupTitleLabels()
        
        // 3.底线と滚动滑块を設定する
        setupBottomMenuAndScrollLine()
    }
    
    private func setupTitleLabels(){
        //labelのframe共通設定
        //ラベルの幅は、タイトル数に応じて、当前frameの幅を按分する
        let labelW : CGFloat = frame.width / CGFloat(titles.count) //＊swiftは隠式転換がなし
        let labelH : CGFloat = frame.height - kScrollLineH
        let labelY : CGFloat = 0
        
        for(index, title) in titles.enumerated(){
            //1.ラベル作成
            let label = UILabel()
            
            //2.label属性設定
            label.text = title
            label.tag = index
            label.font = UIFont.systemFont(ofSize: 16.0)
            label.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
            label.textAlignment = NSTextAlignment.center
            
            //3.labelのframe設定
            let labelX : CGFloat = labelW * CGFloat(index)
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            
            //4.scrollviewに編集後のlabelを追加する
            scrollView.addSubview(label)
            titleLabels.append(label)
            
            //5.labelに仕草を添加する
            label.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.titleLabelClick(tapGes:)))
            label.addGestureRecognizer(tapGes)
        }
    }
    
    private func setupBottomMenuAndScrollLine(){
        // 1.アンダーライン追加
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.lightGray
        let lineH : CGFloat = 0.5
        bottomLine.frame = CGRect(x: 0, y: frame.height - lineH, width: frame.width, height: lineH)
        addSubview(bottomLine)
        
        // 2.scrollLine追加
        // 2.1. 一番目のラベルを取得する
        guard let firstLabel = titleLabels.first else { return }
        firstLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        // 2.2. scrollLine属性設定
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height - kScrollLineH, width: firstLabel.frame.width, height: kScrollLineH)
        scrollView.addSubview(scrollLine)
    }
}

//labelのクリックイベントを監視する
extension PageTitleView{
    @objc private func titleLabelClick(tapGes : UITapGestureRecognizer){
        // 1.クリック対象ラベルを取得して
        guard let currentLabel = tapGes.view as? UILabel else{ return }
    
        // 2.クリック前のラベルを取得して
        let oldLabel = titleLabels[currentIndex]
    
        // 3.クリック対象ラベルの文字色を切り替えて
        currentLabel.textColor = UIColor(r: kSelectColor.0, g: kSelectColor.1, b: kSelectColor.2)
        oldLabel.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
        
        // 4.最新ラベルのインデックスを保存する
        currentIndex = currentLabel.tag
        
        // 5.scrollLineの位置計算変化
        let scrollLineX = scrollLine.frame.width * CGFloat(currentIndex)
        UIView.animate(withDuration: 0.15, animations: {[weak self] in
            self?.scrollLine.frame.origin.x = scrollLineX
        })
        
        // 6.通知代理
        delegate?.pageTitleView(titleView: self, selectIndex: currentIndex)
    }
}

// MARK:- 外部に提供する方法
// 計算論理さ参考：ios Swift開発項目　DYZBapp 13課
extension PageTitleView{
    func setPageTitleProgress(progress : CGFloat, sourceIndex : Int, targetIndex : Int){
        // 1.sourceLabelとtargetLabelを取る
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        // 2.scrollLineの位置変化処理ロジック
        let moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveX = moveTotalX * progress
        scrollLine.frame.origin.x = sourceLabel.frame.origin.x + moveX
        
        // 3.色は徐々に変化する(複雑)
        // 3.1.変化範囲確定
        let colorDelta = (kSelectColor.0 - kNormalColor.0, kSelectColor.1 - kNormalColor.1, kSelectColor.2 - kNormalColor.2)
        // 3.2.sourceLabel変化
        sourceLabel.textColor = UIColor(r: kSelectColor.0 - colorDelta.0 * progress, g: kSelectColor.1 - colorDelta.1 * progress, b: kSelectColor.2 - colorDelta.2 * progress)
        // 3.3.targetLable変化
        targetLabel.textColor = UIColor(r: kNormalColor.0 + colorDelta.0 * progress, g: kNormalColor.1 + colorDelta.1 * progress, b: kNormalColor.2 + colorDelta.2 * progress)
        
        // 3.4.labelのクリックイベントにて使っているcurrentIndexを更新する
        currentIndex = targetIndex
    }
}

