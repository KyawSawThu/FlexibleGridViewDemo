//
//  CustomView.swift
//  FlexibleGridViewDemo
//
//  Created by OwayEngineer on 06/01/2021.
//

import UIKit

class CustomView: UIViewController {
    
    @IBOutlet weak var customGridView: UIFlexibleGridView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    private func setUp() {
        customGridView.dataSource = self
        customGridView.delegate = self
        
        customGridView.spacing = 6
        customGridView.itemHeight = 36
        customGridView.selectionStyle = .single
        customGridView.contentInsets = UIGridInsets(top: 6, left: 6, bottom: 6, right: 6)
//        customGridView.register(with: CustomItem.self, identifier: "custom_item")
        let nibItem = UINib(nibName: "AnimalItem", bundle: nil)
        customGridView.registerNib(with: nibItem, item: AnimalItem.self, identifier: "animal_item")
    }
    
    private func calculateWidth(for animal: Animal) -> CGFloat {
        let font: UIFont = UIFont.systemFont(ofSize: 17)
        
        let space: CGFloat = 4
        let logoWidth: CGFloat = 24
        let titleWidth: CGFloat = (animal.name as NSString).size(withAttributes: [.font: font]).width + 4
        
        return space + logoWidth + space + titleWidth + space
    }
    
}

extension CustomView: UIFlexibleGridViewDataSource, UIFlexibleGridViewDelegate {
    
    func layoutForGridView(_ flexibleGridView: UIFlexibleGridView) -> UIGridLayout {
        return .custom
    }
    
    func numberOfItemsInGridView(_ flexibleGridView: UIFlexibleGridView) -> Int {
        return Animal.data.count
    }
    
    func flexibleGridView(_ flexibleGridView: UIFlexibleGridView, itemForIndexAt index: Int) -> UIFlexibleGridViewItem {
        let item = flexibleGridView.dequeItem(withIdentifier: "animal_item", for: index) as! AnimalItem
        item.bind(with: Animal.data[index])
        return item
    }
    
    func flexibleGridView(_ flexibleGridView: UIFlexibleGridView, widthForItemAt index: Int) -> CGFloat {
        let animal = Animal.data[index]
        return calculateWidth(for: animal)
    }
    
    func flexibleGridView(_ flexibleGridView: UIFlexibleGridView, didSelectItemAt index: Int) {
        print(Animal.data[index].name)
    }
    
}

class CustomItem: UIFlexibleGridViewItem {
    
    lazy var ivLogo: UIImageView = {
        let iv = UIImageView()
        iv.tintColor = .black
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    } ()
    
    lazy var lbName: UILabel = {
        let lb = UILabel()
        lb.textColor = .black
        lb.font = UIFont.systemFont(ofSize: 17)
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    } ()
    
    required init() {
        super.init(frame: .zero)
        self.setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(with animal: Animal) {
        lbName.text = animal.name
        ivLogo.image = UIImage(named: animal.logo)!
    }
    
    override func onSelected() {
        super.onSelected()
        ivLogo.tintColor = .white
        lbName.textColor = .white
    }
    
    override func onDeselected() {
        super.onDeselected()
        ivLogo.tintColor = .black
        lbName.textColor = .black
    }
    
    private func setUp() {
        addSubview(ivLogo)
        
        NSLayoutConstraint.activate([
            ivLogo.centerYAnchor.constraint(equalTo: centerYAnchor),
            ivLogo.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
            ivLogo.widthAnchor.constraint(equalToConstant: 24),
            ivLogo.heightAnchor.constraint(equalToConstant: 24)
        ])
        
        addSubview(lbName)
        NSLayoutConstraint.activate([
            lbName.centerYAnchor.constraint(equalTo: centerYAnchor),
            lbName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            lbName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4)
        ])
        
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
    }
    
}
