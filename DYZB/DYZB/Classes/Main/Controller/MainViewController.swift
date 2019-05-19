//
//  MainViewController.swift
//  DYZB
//
//  Created by apple on 2019/04/30.
//  Copyright © 2019年 com.btx. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        addChildVc(storyName: "Home")
        addChildVc(storyName: "Live")
        addChildVc(storyName: "Follow")
        addChildVc(storyName: "Profile")
    }

    private func addChildVc(storyName : String){
        // 1.storyboardでコントロールを取得する
        let childVc = UIStoryboard(name: storyName, bundle: nil).instantiateInitialViewController()!
        
        // 2.childVcは子コントロールとして親に追加する
        addChild(childVc)
    }
}
