//
//  BaseVC.swift
//  SVAP_iOS
//
//  Created by 조영준 on 2023/09/17.
//

import UIKit

class BaseVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    override func viewWillLayoutSubviews() {
        configureUI()
        setConstraints()
    }
    
    func configureUI() {
        
    }
    func setConstraints() {
        
    }
}
