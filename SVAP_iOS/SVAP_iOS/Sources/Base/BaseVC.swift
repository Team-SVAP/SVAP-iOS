import UIKit
import SnapKit
import Then
import Moya

class BaseVC: UIViewController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    override func viewWillLayoutSubviews() {
        configureUI()
        setupConstraints()
    }
    
    func configureUI() {
        
    }
    func setupConstraints() {
        
    }
}
