//
//  coreTabPage.swift
//  coreTabPage
//
//  Created by zkhCreator on 6/14/16.
//  Copyright © 2016 zkhCreator. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class coreTabPage: UIView,UIScrollViewDelegate {
    
    enum Position:Int {
        case top = 0,middle,bottom
    }
    
    var delegate:coreTabViewDelegate?
    
//    界面样式
    var tabMargin:CGFloat = 10
    let tabHight:CGFloat = 40
    var titleSize:CGFloat = 14
    var maxButtonWidth:CGFloat = 0
    let tabBackground:UIColor = UIColor.white
    var baseLine:UIView = {
        let line = UIView()
        line.backgroundColor = UIColor.red
        line.setWidth(0)
        line.setHeight(2)
        return line
    }()
    
//    基本属性
    lazy var viewControllersArray:Array<UIViewController> = Array<UIViewController>()
    lazy var tabsArray:Array<UILabel> = Array<UILabel>()
    lazy var redDotsArray:Array<UIView> = Array<UIView>()
    lazy var currentPageTag:Int = 0
    lazy var startTag:Int = 0
    lazy var selectedLineOffsetXBeforeMoving:CGFloat = 0
    lazy var speed:CGFloat = 20
    
//    两个scrollView
    lazy var bodyScrollView:UIScrollView = {
        let bodyScrollView = UIScrollView.init()
        bodyScrollView.isPagingEnabled = true
        bodyScrollView.isUserInteractionEnabled = true
        bodyScrollView.bounces = false
        bodyScrollView.showsHorizontalScrollIndicator = false
        bodyScrollView.autoresizingMask = UIViewAutoresizing(arrayLiteral: .flexibleHeight,.flexibleBottomMargin,.flexibleWidth)
        return bodyScrollView
    }()
    lazy var tabScrollView:UIScrollView = {
        let tabScrollView = UIScrollView.init()
        tabScrollView.isUserInteractionEnabled = true
        tabScrollView.showsHorizontalScrollIndicator = false
        tabScrollView.autoresizingMask = UIViewAutoresizing(arrayLiteral: .flexibleHeight,.flexibleBottomMargin,.flexibleWidth)
        return tabScrollView
    }()
    
//    用来判断状态的值
    var isBuild:Bool = false
    var isUsingDragging:Bool = false    //用来防止在点击tab的时候调用scrollView
    var continueDraggingNumber:Int = 0
    var startOffset:CGFloat = 0
    var customLine:Bool = false
    
    func BuildIn() {
        isBuild = true
        let count = self.delegate?.numberOfPage()
        self.addSubview(bodyScrollView)
        self.addSubview(tabScrollView)
        tabScrollView.addSubview(baseLine)
        if ((self.delegate?.setSelectLineStye?()) != nil) {
            customLine = true
            
//          直接通过baseLine = changView的话后面值会消失，不知道原因
            
            let changeView = (self.delegate?.setSelectLineStye!())!
            
            baseLine.setHeight(changeView.height)
            baseLine.backgroundColor = changeView.backgroundColor
            baseLine.layer.masksToBounds = changeView.layer.masksToBounds
            baseLine.layer.cornerRadius = changeView.layer.cornerRadius
        }
        
        bodyScrollView.frame = CGRect(x: 0, y: tabHight, width: self.width, height: self.height)
        tabScrollView.frame = CGRect(x: self.left, y: self.top , width: self.width, height: tabHight)
        
        bodyScrollView.delegate = self;
        
        for i in 0..<count! {
//            将vc放入scrollView和array
            let vc = self.delegate?.viewControllerOfIndex(i)
            viewControllersArray.append(vc!)
            bodyScrollView.addSubview(vc!.view)
            
//            将tabButton放入array
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(selectTabButton(_:)))
            let tabItem = UILabel()
            tabItem.text = vc?.title
            tabItem.baselineAdjustment = UIBaselineAdjustment.alignCenters
            tabItem.textAlignment = .center
            tabItem.font = UIFont.systemFont(ofSize: titleSize)
            tabItem.textColor = UIColor.black
            tabItem.addGestureRecognizer(tapGes)
            tabItem.isUserInteractionEnabled = true
            tabItem.tag = i
            tabScrollView.addSubview(tabItem)
            tabsArray.append(tabItem)
            
//            将红点加入tabButton
            let redDot = UIView()
            redDot.backgroundColor = UIColor.red
            redDot.layer.masksToBounds = true
            redDot.isHidden = true
            redDot.tag = i
            redDotsArray.append(redDot)
            tabItem.addSubview(redDot)
        }
        
        tabScrollView.backgroundColor = tabBackground
        isBuild = true
        
        self.setNeedsLayout()
        
    }
    
    fileprivate func buttonTitleRealSize(_ button:UIButton) -> CGSize {
        let string =  (button.titleLabel?.text)! as NSString
        return string.size(attributes: [NSFontAttributeName:(button.titleLabel?.font)!])
    }
    
    override func layoutSubviews() {
        if isBuild {
//          仅在设置完成后，设置界面的位置，设置两个scrollView，防止占用过多资源
            bodyScrollView.contentSize = CGSize.init(width: self.width * CGFloat(viewControllersArray.count) , height: self.tabHight)
            
            var buttonSumWidth:CGFloat = 0
//          获得按钮的总长度
//          为了防止某些按钮太宽导致样式变丑
            for i in 0..<tabsArray.count {
                let button = tabsArray[i]
                if maxButtonWidth < button.currentSize().width {
                    maxButtonWidth = button.currentSize().width + 10
                }
            }
            
//          获得按钮总长度
            buttonSumWidth = maxButtonWidth * CGFloat( tabsArray.count )
            
//          获取tab总长度，如果小于self的宽度，那么均分，否则用scrollView滚动，margin变小
            if self.width > buttonSumWidth {
                maxButtonWidth = ( self.width - tabMargin * 2 ) / CGFloat( tabsArray.count )
            }else{
                speed = 10
            }

            var sumTabWidth:CGFloat = tabMargin
            for i in 0..<viewControllersArray.count {
//                内容的scrollView
                let vc:UIViewController = viewControllersArray[i]
                vc.view.frame = CGRect.init(x: bodyScrollView.width * CGFloat(i), y: 0, width: bodyScrollView.width, height: bodyScrollView.height)
                
//                tab的scrollView
                let btn:UILabel = tabsArray[i]
                btn.frame = CGRect(x: sumTabWidth, y: 0, width: maxButtonWidth, height: tabHight)
                if ((self.delegate?.setTabColorNormal?()) != nil) {
                    btn.textColor = self.delegate?.setTabColorNormal!()
//                    btn.setTitleColor(self.delegate?.setTabColorNormal!(), for: UIControlState())
                }
                
//                if ((self.delegate?.setTabColorSelected?()) != nil) {
//                    btn.setTitleColor(self.delegate?.setTabColorSelected!(), for: UIControlState.selected)
//                }
                
                
//                小红点的frame
                let redDot = redDotsArray[i]
                redDot.frame = CGRect.init(x: (maxButtonWidth / 2) + (btn.currentSize().width/2), y: (btn.height / 2) - btn.currentSize().height / 2 - 3, width: 8, height: 8)
                redDot.layer.cornerRadius = redDot.width / 2
                
                
                sumTabWidth += maxButtonWidth
            }
            sumTabWidth += tabMargin
            tabScrollView.contentSize = CGSize.init(width: sumTabWidth,height: tabHight)
            
//            设置起始页
            
            if ((self.delegate?.setFirstPageTag?()) == nil) {
                startTag = 0
            }else if self.delegate?.setFirstPageTag?() > tabsArray.count {
                startTag = 0
            }else
            {
                startTag = (self.delegate?.setFirstPageTag?())!
                bodyScrollView.setContentOffset(CGPoint.init(x:self.width * CGFloat( startTag ), y: 0), animated: false)
            }
            self.baseLine.setWidth(self.tabsArray[startTag].currentSize().width)
            self.baseLine.setCenterX(self.tabsArray[startTag].centerX)
            
//            self.baseLine.setTop(self.tabScrollView.height - 2)
            
            if self.delegate?.setSelectLinePosition?() != nil {
                if let position = Position.init(rawValue: (self.delegate?.setSelectLinePosition?())!){
                    switch position {
                    case .top:
                        baseLine.setTop(0)
                    case .middle:
                        self.baseLine.setCenterY(self.tabScrollView.centerY)
                    case .bottom:
                        fallthrough
                    default:
                        self.baseLine.setTop(self.tabScrollView.height - 2)
                    }
                }
            }
            selectPage(startTag, isAnimate: false)
        }
    }
    
    fileprivate func selectPage(_ index:Int,isAnimate:Bool) {
//        tab的跳转
        currentPageTag = index
        let currentButton = tabsArray[index]
        
        var buttonWidth:CGFloat = 0
        if customLine {
            buttonWidth = self.tabsArray[index].currentSize().width + 5
        }else{
            buttonWidth = self.tabsArray[index].currentSize().width
        }
        
        if isAnimate {
//            let x = self.tabsArray[index].centerX - buttonWidth/2
//            let rect = CGRect(x: x, y: self.baseLine.layer.frame.origin.y, width: buttonWidth, height: self.baseLine.height)
//            let animation = CABasicAnimation(keyPath: "frame")
//            animation.fromValue = self.baseLine
//            animation.toValue = rect
//            animation.duration = 0.25
//            self.baseLine.layer.add(animation, forKey: "selectPage")
//            self.baseLine.layer.frame = rect
//            self.selectedLineOffsetXBeforeMoving = self.baseLine.origin.x
            
            UIView.animate(withDuration: 0.25, animations: {
//              设置下划线的位置
                self.baseLine.setWidth(buttonWidth)
                self.baseLine.setCenterX(self.tabsArray[index].centerX)
                self.selectedLineOffsetXBeforeMoving = self.baseLine.origin.x
            })
        }else{
            self.baseLine.setWidth(buttonWidth)
            self.baseLine.setCenterX(self.tabsArray[index].centerX)
            self.selectedLineOffsetXBeforeMoving = self.baseLine.origin.x
        }
        
        tabScrollView.scrollRectToVisible(currentButton.frame, animated: true)
        
//        内容scrollView的跳转
        switchContent(index,isAnimate: isAnimate)

        hideRedDot(index)
    }
    
    fileprivate func selectPage(_ index:Int) {
        self.selectPage(index, isAnimate: false)
    }
    
    fileprivate func switchContent(_ index:Int,isAnimate:Bool) {
        bodyScrollView.setContentOffset(CGPoint(x: CGFloat(index) * self.width, y: 0), animated: true)
        isUsingDragging = false
    }
    
    func selectTabButton(_ sender:UIGestureRecognizer) {
        let label = sender.view as! UILabel
        for item in tabsArray {
            item.textColor = UIColor.black
        }
        
        if ((self.delegate?.setTabColorSelected?()) != nil) {
            label.textColor = self.delegate?.setTabColorSelected?()
        }
        
        label.textColor = UIColor.red
        
        selectPage(label.tag,isAnimate: true)
    }
    
//    滚动条移动的动画
    func moveSelectedLineByScrollWithOffsetX(_ offsetX:CGFloat) {
        let textGap:CGFloat = (self.width - self.tabMargin * 2 - self.baseLine.width * CGFloat( tabsArray.count )) / ( CGFloat( self.tabsArray.count ) * 2)
        
        let moveLength:CGFloat = selectedLineOffsetXBeforeMoving + ( offsetX * (textGap + baseLine.width + speed)) / UIScreen.main.bounds.width //用来防止超过左右最大距离
        let maxRightMove:CGFloat = selectedLineOffsetXBeforeMoving + textGap * 2 + baseLine.width
        let maxLeftMove:CGFloat = selectedLineOffsetXBeforeMoving - textGap * 2 - baseLine.width
        var lineMoveActually:CGFloat = 0
        
        var isContinueDragging:Bool = false
        //多手指移动判断
        if continueDraggingNumber > 1 {
            isContinueDragging = true
        }
        
        if moveLength > maxRightMove && !isContinueDragging {
            lineMoveActually = maxRightMove
        }else if moveLength < maxLeftMove && !isContinueDragging {
            lineMoveActually = maxLeftMove
        }else{
//            如果存在多指移动，导致移动过长需要阻止
            if isContinueDragging {
                if moveLength > bodyScrollView.contentSize.width - (tabMargin + textGap + baseLine.width){
                    lineMoveActually = bodyScrollView.contentSize.width - (tabMargin + textGap + baseLine.width)
                }else if moveLength < self.tabMargin + textGap{
                    lineMoveActually = self.tabMargin + textGap
                }else{
                    lineMoveActually = moveLength
                }
            }else{
                lineMoveActually = moveLength
            }
        }
        
        baseLine.frame = CGRect.init(origin: CGPoint.init(x: lineMoveActually, y: baseLine.frame.origin.y), size: baseLine.frame.size)
    }
    
    func showRedDot(_ index:Int) {
        redDotsArray[index].isHidden = false
    }
    
    func hideRedDot(_ index:Int) {
        redDotsArray[index].isHidden = true
    }
    
    // MARK:scrollView Delegate
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView.isEqual(bodyScrollView) {
            continueDraggingNumber += 1
            
            startOffset = bodyScrollView.contentOffset.x
            isUsingDragging = true
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isEqual(bodyScrollView) {
            let offsetX = scrollView.contentOffset.x - startOffset
            if isUsingDragging {
                moveSelectedLineByScrollWithOffsetX(offsetX)
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.isEqual(self.bodyScrollView) {
            let index:Int = Int( scrollView.contentOffset.x / self.bounds.size.width )
            selectPage(index, isAnimate: true)
            isUsingDragging = true
        }
    }
}

@objc protocol coreTabViewDelegate {
    
    @objc optional func setSelectLinePosition() -> Int
    @objc optional func setFirstPageTag() -> Int
    @objc optional func setSelectLineStye() -> UIView
    @objc optional func setTabColorNormal() -> UIColor
    @objc optional func setTabColorSelected() -> UIColor
    
    func viewControllerOfIndex(_ index:Int) -> UIViewController
    func numberOfPage() -> Int
    
}
