//
//  IndexView.swift
//  FlexibleGridViewDemo
//
//  Created by OwayEngineer on 28/12/2020.
//

import UIKit

class IndexView: UIViewController {
    
    @IBOutlet weak var categoryGridView: UIFlexibleGridView!
    
    private var mMovies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpCategoryGridView()
    }
    
    private func setUpCategoryGridView() {
        categoryGridView.dataSource = self
        categoryGridView.delegate = self
        
        categoryGridView.alignment = .left
        categoryGridView.spacing = 6
        categoryGridView.itemHeight = 36
        categoryGridView.selectionStyle = .single
        categoryGridView.showsScrollIndicator = false
        categoryGridView.contentInsets = UIGridInsets(top: 6, left: 6, bottom: 6, right: 6)
        categoryGridView.register(with: UIFlexibleGridViewItem.self, identifier: "category_item")
    }
    
}

extension IndexView: UIFlexibleGridViewDataSource, UIFlexibleGridViewDelegate {
    
    func layoutForGridView(_ flexibleGridView: UIFlexibleGridView) -> UIGridLayout {
        return .auto
    }
    
    func numberOfItemsInGridView(_ flexibleGridView: UIFlexibleGridView) -> Int {
        return categoryData.count
    }
    
    func flexibleGridView(_ flexibleGridView: UIFlexibleGridView, itemForIndexAt index: Int) -> UIFlexibleGridViewItem {
        let item = flexibleGridView.dequeItem(withIdentifier: "category_item", for: index) as UIFlexibleGridViewItem
        item.titleLabel.text = categoryData[index]
        return item
    }
    
    func flexibleGridView(_ flexibleGridView: UIFlexibleGridView, didSelectItemAt index: Int) {
        let item = flexibleGridView.itemForIndexAt(index: index)
        print(item.titleLabel.text!)
    }
    
    func flexibleGridView(_ flexibleGridView: UIFlexibleGridView, widthForItemAt index: Int) -> CGFloat {
        let screenWidth: CGFloat = UIScreen.main.bounds.size.width
        let numberOfRows: CGFloat = 3
        let totalPadding: CGFloat = (numberOfRows + 1) * 6
        let itemWidth: CGFloat = (screenWidth - totalPadding) / numberOfRows
        return itemWidth
    }
    
}



let categoryData = [
    "UILabel", "UIButton", "UITextField", "UIText",
    "UIStackView", "UIImageView", "UITableView", "UISwitch",
    "UITabView", "UICollectionView", "UIImageView",
    "UIBarButtonItem",  "UITabBar", "UINavigationController",
    "UIScrollView", "UISlider", "UIPickerView", "UIPageControl",
    "UISegmentedControl", "UIImage", "UIColor", "UIFont",
    "UITextView", "UIActivityIndicatorView",
    "String", "Double", "Boolean", "Int",
    "CGRect", "CGSize", "CGFloat", "CGColor",
    "UIScrollView", "UISlider", "UIPickerView", "UIPageControl",
    "UITabView", "UICollectionView", "UIImageView",
    "UISegmentedControl", "UIImage", "UIColor", "UIFont",
    "UILabel", "UIButton", "UITextField", "UIText",
    "UITabView", "UICollectionView", "UIImageView"
]
