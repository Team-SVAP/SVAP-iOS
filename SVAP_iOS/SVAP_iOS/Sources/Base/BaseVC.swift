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
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
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
