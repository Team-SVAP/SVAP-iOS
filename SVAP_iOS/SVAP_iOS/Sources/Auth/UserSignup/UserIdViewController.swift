import UIKit
import SnapKit
import Then

class UserIdViewController: BaseVC {
    
    
    private let signupLabel = UILabel().then {
        $0.text = "회원가입"
        $0.textColor = UIColor(named: "gray-700")
        $0.font = UIFont(name: "IBMPlexSansKR-SemiBold", size: 16)
    }
    private let progressLabel = UILabel().then {
        $0.text = "1/4"
        $0.textColor = UIColor(named: "gray-700")
        $0.font = UIFont(name: "IBMPlexSansKR-SemiBold", size: 16)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
//    override func configureUI() {
//        
//    }
//    override func setConstraints() {
//        <#code#>
//    }
}
