//
//  UIFlexibleGridViewComponents.swift
//  FlexibleGridViewDemo
//
//  Created by OwayEngineer on 31/12/2020.
//

import UIKit

protocol UIFlexibleGridViewDataSource {
    func layoutForGridView(_ flexibleGridView: UIFlexibleGridView) -> UIGridLayout
    func numberOfItemsInGridView(_ flexibleGridView: UIFlexibleGridView) -> Int
    func flexibleGridView(_ flexibleGridView: UIFlexibleGridView, itemForIndexAt index: Int) -> UIFlexibleGridViewItem
}

protocol UIFlexibleGridViewDelegate {
    func flexibleGridView(_ flexibleGridView: UIFlexibleGridView, didSelectItemAt index: Int)
    func flexibleGridView(_ flexibleGridView: UIFlexibleGridView, heightOfGrid height: CGFloat)
    func flexibleGridView(_ flexibleGridView: UIFlexibleGridView, widthForItemAt index: Int) -> CGFloat
}

extension UIFlexibleGridViewDelegate {
    func flexibleGridView(_ flexibleGridView: UIFlexibleGridView, didSelectItemAt index: Int) {}
    func flexibleGridView(_ flexibleGridView: UIFlexibleGridView, heightOfGrid height: CGFloat) {}
    func flexibleGridView(_ flexibleGridView: UIFlexibleGridView, widthForItemAt index: Int) -> CGFloat { return 0 }
}

class UIFlexibleGridViewItemSelector: UITapGestureRecognizer {
    let item: UIFlexibleGridViewItem
    
    init(target: AnyObject, action: Selector, item: UIFlexibleGridViewItem) {
        self.item = item
        super.init(target: target, action: action)
    }
}

class UIFlexibleGridViewItemEditor: UILongPressGestureRecognizer {
    let item: UIFlexibleGridViewItem
    
    init(target: AnyObject, action: Selector, item: UIFlexibleGridViewItem) {
        self.item = item
        super.init(target: target, action: action)
    }
}

enum UIFlexibleGridViewAlignment {
    case left
    case center
    case justify
    case right
    
    var value: UIStackView.Alignment {
        switch self {
        case .left:
            return .leading
        case .center:
            return .center
        case .justify:
            return .fill
        case .right:
            return .trailing
        }
    }
}

enum UIFlexibleGridViewSelectionStyle {
    case none
    case single
    case multiple
}

enum UIGridLayout {
    case auto
    case custom
}

struct UIGridInsets {
    let top: CGFloat
    let left: CGFloat
    let bottom: CGFloat
    let right: CGFloat
    
    init(top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) {
        self.top = top
        self.left = left
        self.bottom = bottom
        self.right = right
    }
}
