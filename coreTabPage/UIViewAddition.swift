//
//  UIViewAddition.swift
//  corePageTab
//
//  Created by zkhCreator on 6/13/16.
//  Copyright © 2016 zkhCreator. All rights reserved.
//

import UIKit

extension UIView{
    var visible: Bool { return !self.isHidden}
    var left: CGFloat { return self.frame.origin.x }
    var top: CGFloat { return self.frame.origin.y }
    var right: CGFloat { return self.frame.origin.x+self.frame.size.width }
    var bottom: CGFloat { return self.frame.origin.y + self.frame.size.height }
    var centerX: CGFloat { return self.center.x }
    var centerY: CGFloat { return self.center.y }
    var width: CGFloat { return self.frame.size.width }
    var height: CGFloat { return self.frame.size.height }
    var screenX: CGFloat {
        var x:CGFloat = 0
        var view:UIView = self
        while !view.isEqual(nil) {
            x += view.left
            view = view.superview!
        }
        return x
    }
    var screenY: CGFloat {
        var y:CGFloat = 0
        var view:UIView = self
        while !view.isEqual(nil) {
            y += view.left
            view = view.superview!
        }
        return y
    }
    var screenViewX: CGFloat {
        var x:CGFloat = 0
        var view:UIView = self
        while !view.isEqual(nil) {
            x += view.left
            
            if view.isKind(of: UIScrollView.self) {
                let scrollView = view as! UIScrollView
                x -= scrollView.contentOffset.x
            }
            view = view.superview!
        }
        return x
    }
    
    var screenViewY:CGFloat{
        var y:CGFloat = 0;
        var view:UIView = self
        while !view.isEqual(nil) {
            y += view.top
            if view.isKind(of: UIScrollView.self) {
                let scrollView = view as! UIScrollView
                y -= scrollView.contentOffset.y
            }
            view = view.superview!
        }
        return y
    }
    
    var screenFrame:CGRect { return CGRect(x: self.screenViewX, y: self.screenViewY, width: self.width, height: self.height) }
    var origin: CGPoint { return self.frame.origin }
    var size: CGSize { return self.frame.size}
    
    func setVisible(_ visible:Bool) {
        self.isHidden = !visible
    }
    
    func setLeft(_ left:CGFloat) {
        var frame = self.frame
        frame.origin.x = left
        self.frame = frame
    }
    
    func setTop(_ y:CGFloat) {
        var frame = self.frame
        frame.origin.y = y
        self.frame = frame
    }
    
    func setRight(_ right:CGFloat) {
        var frame = self.frame
        frame.origin.x = right - frame.size.width
        self.frame = frame
    }
    
    func setBottom(_ bottom:CGFloat) {
        var frame = self.frame
        frame.origin.y = bottom - frame.size.height
        self.frame = frame
    }
    
    func setCenterX(_ centerX:CGFloat) {
        self.center = CGPoint(x: centerX, y: self.centerY)
    }
    
    func setCenterY(_ centerY:CGFloat) {
        self.center = CGPoint(x: self.centerX, y: centerY)
    }
    
    func setWidth(_ width:CGFloat) {
        var frame = self.frame
        frame.size.width = width
        self.frame = frame
    }
    
    func setHeight(_ height:CGFloat) {
        var frame = self.frame
        frame.size.height = height
        self.frame = frame
    }
    
    func setOrigin(_ origin:CGPoint) {
        var frame = self.frame
        frame.origin = origin
        self.frame = frame
    }
    
    func setSize(_ size:CGSize) {
        var frame = self.frame
        frame.size = size
        self.frame = frame
    }
    
    func offsetFromView(_ otherView:UIView) -> CGPoint {
        var x:CGFloat = 0
        var y:CGFloat = 0
        var view = self
        while !view.isEqual(nil) && !view.isEqual(otherView) {
            x += view.left
            y += view.top
            view = view.superview!
        }
        return CGPoint.init(x: x,y: y)
    }
    
    func descendantOrSelWithClass<T>(_ cls: T) -> UIView? {
        if self is T {
            return self
        }else if (self.superview != nil) {
            return self.superview?.descendantOrSelWithClass(cls)
        }else{
            return nil
        }
    }
    
    func removeAllSubViews() {
        while self.subviews.count > 0 {
            let lastView:UIView = (self.subviews.last)!
            lastView.removeFromSuperview()
        }
    }
    
    func addSubViews(_ views:Array<UIView>) {
        for v in views {
            self.addSubview(v)
        }
    }
    
}

extension UILabel{
    func currentSize() -> CGSize {
        let label = UILabel()
        label.font = self.font
        label.textColor = self.textColor
        label.textAlignment = self.textAlignment
        label.text = self.text
        label.sizeToFit()
        
        return label.frame.size
    }
}
