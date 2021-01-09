//
//  UIFlexibleGridView.swift
//  FlexibleGridViewDemo
//
//  Created by OwayEngineer on 28/12/2020.
//

import UIKit

class UIFlexibleGridView: UIView {
    
    //MARK:- SubViews
    private let scrollView: UIScrollView = UIScrollView()
    private let containerView: UIView = UIView()
    
    //MARK:-  PROPERTIES
    
    var delegate: UIFlexibleGridViewDelegate?
    var dataSource: UIFlexibleGridViewDataSource?
    
    var spacing: CGFloat = 4
    var itemHeight: CGFloat = 36
    var contentInsets: UIGridInsets = UIGridInsets(top: 0, left: 0, bottom: 0, right: 0)

    var showsScrollIndicator: Bool = true
    var alignment: UIFlexibleGridViewAlignment = .left
    var selectionStyle: UIFlexibleGridViewSelectionStyle = .multiple
    
    private var layout: UIGridLayout? = nil
    private var items: [UIFlexibleGridViewItem] = []
    private var registered: [String: UIFlexibleGridViewItem.Type] = [:]
    private var numberOfItems: Int = 0
    private var nibItem: UINib?
    
    private var shame: Bool = false
    
    //MARK:- INITIALIZATIONS
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    

    override func layoutSubviews() {
        super.layoutSubviews()
        if !shame { self.shame = true; return }
        self.initDataSource()
        self.items.count > 0 ? self.commonInit() : nil
    }
    
    private func commonInit() {
        
        scrollView.showsVerticalScrollIndicator = showsScrollIndicator
        scrollView.backgroundColor = .clear
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.backgroundColor = .clear
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            containerView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        ])
        
        addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        let vStack = generateVStack()
        var hStack = generateHStack()
        
        var height: CGFloat = 0
        var rowWidth: CGFloat = 0
        for (index, item) in items.enumerated() {
            item.translatesAutoresizingMaskIntoConstraints = false
            
            var itemWidth: CGFloat = 0
            if layout! == .auto {
                itemWidth = item.titleLabel.intrinsicContentSize.width + 32
            } else {
                guard let delegate = delegate else { fatalError("Delegate Initialization not found.") }
                itemWidth = delegate.flexibleGridView(self, widthForItemAt: index)
            }
            rowWidth += itemWidth + spacing
            
            let insets = contentInsets.left + contentInsets.right
            if rowWidth < frame.size.width - insets  {
                hStack.addArrangedSubview(item)
            } else {
                vStack.addArrangedSubview(hStack)
                hStack = generateHStack()
                hStack.addArrangedSubview(item)
                rowWidth = itemWidth + spacing
            }
            
            if alignment != .justify {
                item.widthAnchor.constraint(equalToConstant: itemWidth).isActive = true
            }
            
            vStack.addArrangedSubview(hStack)
            height = CGFloat(vStack.subviews.count) * (itemHeight + spacing)
        }
        
        height += contentInsets.top + contentInsets.bottom
        
        vStack.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(vStack)
        
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: contentInsets.top),
            vStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: contentInsets.left),
            vStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -contentInsets.right),
            vStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -contentInsets.bottom),
            containerView.heightAnchor.constraint(equalToConstant: height)
        ])
        
        scrollView.contentSize = CGSize(width: frame.width, height: height)
        
    }
    
    private func initDataSource() {
        guard let dataSource = dataSource else { return }
        layout = dataSource.layoutForGridView(self)
        numberOfItems = dataSource.numberOfItemsInGridView(self)
        
        for index in 0..<numberOfItems {
            let item = dataSource.flexibleGridView(self, itemForIndexAt: index)
            self.configureGesutres(for: item)
            self.items.append(item)
        }
    }
    
    private func configureGesutres(for item: UIFlexibleGridViewItem) {
        item.isUserInteractionEnabled = true
        let tap = UIFlexibleGridViewItemSelector(target: self, action: #selector(didSelectItem(_:)), item: item)
        item.addGestureRecognizer(tap)
        let press = UIFlexibleGridViewItemEditor(target: self, action: #selector(didPressItem(_:)), item: item)
        item.addGestureRecognizer(press)
    }
    
    @objc fileprivate func didSelectItem(_ sender: UIFlexibleGridViewItemSelector) {
        delegate?.flexibleGridView(self, didSelectItemAt: sender.item.tag)
        
        let item = items[sender.item.tag]
        if selectionStyle != .none {
            item.onSelected()
            
            if selectionStyle == .single {
                _ = items.filter{ $0 != item }.map { $0.onDeselected() }
            }
        }
        
    }
    
    @objc fileprivate func didPressItem(_ sender: UIFlexibleGridViewItemEditor) {
        print("long press \(sender.item.tag)")
    }
    
    private func generateVStack() -> UIStackView {
        let vStack = UIStackView()
        vStack.alignment = alignment.value
        vStack.distribution = .fillEqually
        vStack.axis = .vertical
        vStack.spacing = spacing
        return vStack
    }
    
    private func generateHStack() -> UIStackView {
        let hStack = UIStackView()
        hStack.alignment = .fill
        hStack.distribution = .fillProportionally
        hStack.axis = .horizontal
        hStack.spacing = spacing
        return hStack
    }
    
    //MARK:- COMMUNICATION METHIODS
    
    func register<UIFlexibleGridViewItemClass: UIFlexibleGridViewItem>(with item: UIFlexibleGridViewItemClass.Type, identifier: String) {
        registered[identifier] = UIFlexibleGridViewItemClass.self
    }
    
    func registerNib<UIFlexibleGridViewItemClass: UIFlexibleGridViewItem>(with nib: UINib, item: UIFlexibleGridViewItemClass.Type, identifier: String) {
        nibItem = nib
        registered[identifier] = UIFlexibleGridViewItemClass.self
    }
    
    func dequeItem(withIdentifier identifier: String, for index: Int) -> UIFlexibleGridViewItem {
        let isRegistered = registered.contains(where: { $0.key == identifier })
        if !isRegistered { fatalError("GridItem is not registered.") }
        
        if let nib = nibItem {
            let item = registered[identifier]!.init()
            let nibView = nib.instantiate(withOwner: item, options: nil).first as! UIView
            nibView.frame = item.bounds
            item.addSubview(nibView)
            item.tag = index
            return item
        } else {
            let item = registered[identifier]!.init()
            item.tag = index
            return item
        }
        
    }
    
    func itemForIndexAt(index: Int) -> UIFlexibleGridViewItem {
        return items[index]
    }
    
    func reloadData() {
        items.removeAll()
        containerView.subviews.forEach { $0.removeFromSuperview() }
        setNeedsLayout()
        layoutIfNeeded()
    }
    
}


//let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: "longPressed:")
//    self.view.addGestureRecognizer(longPressRecognizer)
//
//func tapped(sender: UITapGestureRecognizer)
//{
//    println("tapped")
//}
