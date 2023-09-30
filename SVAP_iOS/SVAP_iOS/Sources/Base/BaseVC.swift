import UIKit
import SnapKit
import Then
import Moya

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
        setupConstraints()
    }
    
    func configureUI() {
        
    }
    func setupConstraints() {
        
    }
}
