import UIKit

class CreatePetitionViewController: BaseVC {

    var isClick = false
    let leftButton = UIButton(type: .system)
    let rightButton = UIButton(type: .system)
    private let titleLabel = UILabel().then {
        $0.text = "*제목"
        $0.textColor = UIColor(named: "gray-700")
        $0.font = UIFont(name: "IBMPlexSansKR-Medium", size: 14)
    }
    private let enterTitleTextField = CustomTextField(placeholder: "제목을 입력하세요.", isSecure: false).then {
        $0.layer.borderColor = UIColor(named: "gray-400")?.cgColor
    }
    private let typeLabel = UILabel().then {
        $0.text = "*종류"
        $0.textColor = UIColor(named: "gray-700")
        $0.font = UIFont(name: "IBMPlexSansKR-Medium", size: 14)
    }
    private let placeLabel = UILabel().then {
        $0.text = "*위치태그"
        $0.textColor = UIColor(named: "gray-700")
        $0.font = UIFont(name: "IBMPlexSansKR-Medium", size: 14)
    }
    private let contentLabel = UILabel().then {
        $0.text = "*내용"
        $0.textColor = UIColor(named: "gray-700")
        $0.font = UIFont(name: "IBMPlexSansKR-Medium", size: 14)
    }
    private let enterContentTextField = CustomTextField(placeholder: "내용을 입력하세요.", isSecure: false).then {
        $0.layer.borderColor = UIColor(named: "gray-400")?.cgColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarSetting()
    }

    override func configureUI() {
        super.configureUI()
        
        [
            titleLabel,
            enterTitleTextField
        ].forEach({ view.addSubview($0) })
    }
    override func setupConstraints() {
        super.setupConstraints()
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(104)
            $0.left.equalToSuperview().inset(20)
        }
        enterTitleTextField.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
    }
    private func navigationBarSetting() {
        navigationItem.hidesBackButton = true
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
        title.text = "청원하기"
        title.textColor = UIColor(named: "gray-800")
        title.font = UIFont(name: "IBMPlexSansKR-Medium", size: 14)
        title.textAlignment = .center
        navigationItem.titleView = title
        
        leftButton.setImage(UIImage(named: "leftArrow"), for: .normal)
        leftButton.tintColor = UIColor(named: "gray-700")
        leftButton.addTarget(self, action: #selector(clickLeftBarButton), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
    
        rightButton.setTitle("완료", for: .normal)
        rightButton.setTitleColor(UIColor(named: "gray-600"), for: .normal)
        rightButton.titleLabel?.font = UIFont(name: "IBMPlexSansKR-Medium", size: 16)
        rightButton.addTarget(self, action: #selector(clickRightBarButton), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
    }
    @objc func clickLeftBarButton() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func clickRightBarButton() {
        self.navigationController?.popViewController(animated: true)
        //청원등록 서버통신
    }
    @objc func clickButton() {
        isClick.toggle()
        if isClick {
//            self.navigationController?.present(CustomMenu(), animated: true)
        } else {
        }
    }
}
