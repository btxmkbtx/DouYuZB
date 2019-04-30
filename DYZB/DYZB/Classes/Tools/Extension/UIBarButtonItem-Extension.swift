//
//  UIBarButtonItem-Extension.swift
//  DYZB
//
//  Created by apple on 2019/04/29.
//  Copyright © 2019年 com.btx. All rights reserved.
//

import UIKit

extension UIBarButtonItem{
    //クラス方法で拡張の例
    class func createItem(imageName : String, highImageName : String, size : CGSize) ->UIBarButtonItem{
        let btn = UIButton()
        
        btn.setImage(UIImage(named: imageName), for: UIControl.State.normal)
        btn.setImage(UIImage(named: highImageName), for: UIControl.State.highlighted)
        btn.frame = CGRect(origin: CGPoint.zero, size: size)
        
        return UIBarButtonItem(customView: btn)
    }
    
    //便利構造函数で拡張する：条件１＞convenienceから宣言する　条件２＞明確的にデザイン構造函数を呼出す
    convenience init(imageName : String, highImageName : String = "", size : CGSize = CGSize.zero) {
        //UIButton作成
        let btn = UIButton()
        
        //イメージ設定
        btn.setImage(UIImage(named: imageName), for: UIControl.State.normal)
        if highImageName != "" {
            btn.setImage(UIImage(named: highImageName), for: UIControl.State.highlighted)
        }
        
        //サイズ設定
        if size == CGSize.zero{
            btn.sizeToFit()
        }else{
            btn.frame = CGRect(origin: CGPoint.zero, size: size)
        }
        
        //UIBarButtonItem作成
        self.init(customView: btn)
    }
}
