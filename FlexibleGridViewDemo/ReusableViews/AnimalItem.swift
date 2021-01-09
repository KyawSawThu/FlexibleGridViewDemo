//
//  AnimalItem.swift
//  FlexibleGridViewDemo
//
//  Created by OwayEngineer on 06/01/2021.
//

import UIKit

class AnimalItem: UIFlexibleGridViewItem {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var ivLogo: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    
    required init() {
        super.init(frame: .zero)
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
    
}
