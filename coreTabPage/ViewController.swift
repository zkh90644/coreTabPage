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
        vc1.title = "联系我们"
        vc1.view.backgroundColor = self.randomColor()
        let vc2 = UIViewController()
        vc2.title = "故障解答"
        vc2.view.backgroundColor = self.randomColor()
        let vc3 = UIViewController()
        vc3.title = "经验交流"
        vc3.view.backgroundColor = self.randomColor()
        let vc4 = UIViewController()
        vc4.title = "近期公告"
        vc4.view.backgroundColor = self.randomColor()
        let vc5 = UIViewController()
        vc5.title = "IT资讯"
        vc5.view.backgroundColor = self.randomColor()
        let vc6 = UIViewController()
        vc6.title = "网上报修"
        vc6.view.backgroundColor = self.randomColor()
        
        vcArray.append(vc1)
        vcArray.append(vc2)
        vcArray.append(vc3)
        vcArray.append(vc4)
        vcArray.append(vc5)
        vcArray.append(vc6)
        
        let tabPage = coreTabPage()
        
        tabPage.delegate = self;
        
        view.addSubview(tabPage)
        tabPage.frame = self.view.frame
        
        tabPage.BuildIn()
        tabPage.showRedDot(1)
    }
    
    func randomColor() -> UIColor {
        let r = CGFloat(arc4random() % 255) / 255.0
        let g = CGFloat(arc4random() % 255) / 255.0
        let b = CGFloat(arc4random() % 255) / 255.0
        return UIColor.init(red: r, green: g, blue: b, alpha: 1)
    }
    
    //MARK: corePageDelegate
    func numberOfPage() -> Int {
        return vcArray.count
    }
    
    func viewControllerOfIndex(_ index: Int) -> UIViewController {
        return vcArray[index]
    }
    
    func setFirstPageTag() -> Int {
        return 1
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
}

