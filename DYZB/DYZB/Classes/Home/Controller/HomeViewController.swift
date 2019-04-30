//
//  HomeViewController.swift
//  DYZB
//
//  Created by apple on 2019/04/27.
//  Copyright © 2019年 com.btx. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // UIレイアウト設定
        setupUI()
    }

}

// MARK:- UIレイアウト設定
extension HomeViewController{
    private func setupUI(){
        // 1.ナビセット
        setupNavigationBar()
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
