//
//  ViewController.swift
//  coreTabPage
//
//  Created by zkhCreator on 6/14/16.
//  Copyright © 2016 zkhCreator. All rights reserved.
//

import UIKit

class ViewController: UIViewController,coreTabViewDelegate {

    lazy var vcArray:Array<UIViewController> = Array<UIViewController>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc1 = UIViewController()
        vc1.title = "主页主页主页主页主页主页主页主页主页主页"
        vc1.view.backgroundColor = self.randomColor()
        let vc2 = UIViewController()
        vc2.title = "内容内容内容内容内容内容内容内容内容内容"
        vc2.view.backgroundColor = self.randomColor()
        let vc3 = UIViewController()
        vc3.title = "结束结束结束结束结束结束结束结束结束结束"
        vc3.view.backgroundColor = self.randomColor()
        
        vcArray.append(vc1)
        vcArray.append(vc2)
        vcArray.append(vc3)
        
        let tabPage = coreTabPage()
        
        tabPage.delegate = self;
        
        view.addSubview(tabPage)
        tabPage.frame = self.view.frame
        
        tabPage.BuildIn()
        
    }
    
    func randomColor() -> UIColor {
        let r = CGFloat(arc4random() % 255) / 255.0
        let g = CGFloat(arc4random() % 255) / 255.0
        let b = CGFloat(arc4random() % 255) / 255.0
        return UIColor.init(red: r, green: g, blue: b, alpha: 1)
    }
    
    func numBerOfPage() -> Int {
        return vcArray.count
    }
    
    func viewControllerOfIndex(index: Int) -> UIViewController {
        return vcArray[index]
    }


}

