//
//  coreTabPage.swift
//  coreTabPage
//
//  Created by zkhCreator on 6/14/16.
//  Copyright © 2016 zkhCreator. All rights reserved.
//

import UIKit

class coreTabPage: UIView {
    
    var delegate:coreTabViewDelegate?
    
    
    var tabMargin:CGFloat = 15
    let tabHight:CGFloat = 40
    var titleSize:CGFloat = 14
    var maxButtonWidth:CGFloat = 0
    let tabBackground:UIColor = UIColor.whiteColor()
    
    lazy var viewControllersArray:Array<UIViewController> = Array<UIViewController>()
    lazy var tabsArray:Array<UIButton> = Array<UIButton>()
    lazy var redDotsArray:Array<UIView> = Array<UIView>()
    
    lazy var bodyScrollView:UIScrollView = {
        let bodyScrollView = UIScrollView.init()
        bodyScrollView.pagingEnabled = true
        bodyScrollView.userInteractionEnabled = true
        bodyScrollView.bounces = true
        bodyScrollView.showsHorizontalScrollIndicator = false
        bodyScrollView.autoresizingMask = UIViewAutoresizing(arrayLiteral: .FlexibleHeight,.FlexibleBottomMargin,.FlexibleWidth)
        return bodyScrollView
    }()
    lazy var tabScrollView:UIScrollView = {
        let tabScrollView = UIScrollView.init()
        tabScrollView.pagingEnabled = true
        tabScrollView.userInteractionEnabled = true
        tabScrollView.bounces = true
        tabScrollView.showsHorizontalScrollIndicator = false
        tabScrollView.autoresizingMask = UIViewAutoresizing(arrayLiteral: .FlexibleHeight,.FlexibleBottomMargin,.FlexibleWidth)
        return tabScrollView
    }()
    
    
    
    var isBuild:Bool = false
    
    
    func BuildIn() {
        isBuild = true
        let count = self.delegate?.numBerOfPage()
        self.addSubview(bodyScrollView)
        self.addSubview(tabScrollView)
        
        bodyScrollView.frame = CGRectMake(0, tabHight, self.width, self.height)
        tabScrollView.frame = CGRectMake(self.left, self.top , self.width, tabHight)
        
        for i in 0..<count! {
//            将vc放入scrollView和array
            let vc = self.delegate?.viewControllerOfIndex(i)
            viewControllersArray.append(vc!)
            bodyScrollView.addSubview(vc!.view)
            
//            将tabButton放入array
            let tabItem = UIButton(type: UIButtonType.Custom)
            tabItem.setTitle(vc?.title, forState: UIControlState.Normal)
            tabItem.titleLabel?.baselineAdjustment = UIBaselineAdjustment.AlignCenters
            tabItem.titleLabel?.font = UIFont.systemFontOfSize(titleSize)
            tabItem.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            tabItem.setTitleColor(UIColor.redColor(), forState: UIControlState.Selected)
            tabItem.tag = i
            tabScrollView.addSubview(tabItem)
            tabsArray.append(tabItem)
            
//            将红点加入tabButton
            let redDot = UIView()
            redDot.backgroundColor = UIColor.redColor()
            redDot.layer.masksToBounds = true
            redDot.hidden = true
            redDot.tag = i
            redDotsArray.append(redDot)
        }
        
        tabScrollView.backgroundColor = tabBackground
        isBuild = true
        
        self.setNeedsLayout()
        
    }
    
    func buttonTitleRealSize(button:UIButton) -> CGSize {
        let string =  (button.titleLabel?.text)! as NSString
        return string.sizeWithAttributes([NSFontAttributeName:(button.titleLabel?.font)!])
    }
    
    override func layoutSubviews() {
        if isBuild {
//            在设置完成后，设置界面的位置，设置两个scrollView，防止占用过多资源
            bodyScrollView.contentSize = CGSize.init(width: self.width * CGFloat(viewControllersArray.count) , height: self.tabHight)
            
            var buttonSumWidth:CGFloat = 0
//          获得按钮的总长度
//          为了防止某些按钮太宽导致样式变丑
            for i in 0..<tabsArray.count {
                let button = tabsArray[i]
                if maxButtonWidth < buttonTitleRealSize(button).width {
                    maxButtonWidth = buttonTitleRealSize(button).width + 10
                }
//                buttonSumWidth += buttonTitleRealSize(button).width
            }
//          获得按钮总长度
            buttonSumWidth = maxButtonWidth * CGFloat( tabsArray.count )
            
//            获取tab总长度，如果小于self的宽度，那么均分，否则用scrollView滚动，margin变小
            if self.width > buttonSumWidth {
                maxButtonWidth = ( self.width - tabMargin * 2 ) / CGFloat( tabsArray.count )
            }

            var sumTabWidth:CGFloat = tabMargin
            
            for i in 0..<viewControllersArray.count {
//                内容的scrollView
                let vc:UIViewController = viewControllersArray[i]
                vc.view.frame = CGRect.init(x: bodyScrollView.width * CGFloat(i), y: 0, width: bodyScrollView.width, height: bodyScrollView.height)
                
//                tab的scrollView
                let btn:UIButton = tabsArray[i]
                btn.frame = CGRectMake(sumTabWidth, 0, maxButtonWidth, tabHight)
                
                sumTabWidth += maxButtonWidth
            }
            
            sumTabWidth += tabMargin
            
            tabScrollView.contentSize = CGSize.init(width: sumTabWidth,height: tabHight )
        }
        
        
    }
}

protocol coreTabViewDelegate {
    func viewControllerOfIndex(index:Int) -> UIViewController
    func numBerOfPage() -> Int
}
