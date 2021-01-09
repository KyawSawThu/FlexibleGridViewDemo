//
//  UIFlexibleGridViewItem.swift
//  FlexibleGridViewDemo
//
//  Created by OwayEngineer on 28/12/2020.
//

import UIKit

class UIFlexibleGridViewItem: UIView {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    required init() {
        super.init(frame: CGRect.zero)
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    open func onSelected() {
        backgroundColor = .black
        titleLabel.textColor = .white
    }
    
    open func onDeselected() {
        backgroundColor = .clear
        titleLabel.textColor = .black
    }
    
    open func commonInit() {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
        self.clipsToBounds = true
        
        self.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -4)
        ])
    }
    
}
